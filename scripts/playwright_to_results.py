#!/usr/bin/env python3
"""Konversi JSON reporter Playwright -> skema results/ (CLAUDE.md).

Usage:
    python3 scripts/playwright_to_results.py results/_playwright/last-run.json <modul>

- Judul test harus berformat "SCN-xxxx: ..." — ID dipakai untuk menyalin metadata
  (id/title/category/priority/requirements/screen) apa adanya dari scenario/<modul>/*_scenarios.json.
- Screenshot kegagalan disalin ke artifacts/screenshots/<runId>/<SCN-ID>.png.
- Jika setup login gagal, seluruh skenario ditandai blocked.

Baris terakhir stdout = path file hasil (dipakai scripts/run-playwright.sh).
"""
import json
import os
import re
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCN_RE = re.compile(r"^(SCN-\d+)")
ANSI_RE = re.compile(r"\x1b\[[0-9;]*m")

STATUS_MAP = {
    "passed": "passed",
    "failed": "failed",
    "timedOut": "failed",
    "interrupted": "blocked",
    "skipped": "skipped",
}


def parse_env_md():
    # TEST_ROLE (opsional, mis. "Operator Pusat") memilih akun yang dicatat di environment.user/role;
    # default: akun pertama (perilaku lama). Tidak mengubah fixture mana pun.
    base_url, user, role = None, None, None
    wanted = os.environ.get("TEST_ROLE", "").strip().lower()
    for line in (ROOT / "config" / "env.md").read_text(encoding="utf-8").splitlines():
        cells = [c.strip() for c in line.split("|")]
        if len(cells) >= 4 and cells[1] == "baseUrl":
            base_url = re.sub(r"\(contoh:[^)]*\)", "", cells[2], flags=re.I).strip()
        if len(cells) >= 6 and cells[1].isdigit():
            if "@" in cells[2] and cells[3] and "ISI_DISINI" not in cells[3].upper():
                if user is None and not wanted:
                    user, role = cells[2], cells[4]
                elif wanted and wanted in cells[4].lower() and (user is None or role.lower() != cells[4].lower()):
                    user, role = cells[2], cells[4]
    if base_url and not base_url.startswith("http"):
        base_url = "https://" + base_url
    return {"baseUrl": base_url, "user": user, "role": role}


def load_scenario_meta(module):
    files = list((ROOT / "scenario" / module).glob("*_scenarios.json")) or \
        list((ROOT / "scenario" / module).glob("*.scenarios.json"))
    if not files:
        sys.exit(f"scenario/{module}/*_scenarios.json (atau *.scenarios.json) tidak ditemukan")
    data = json.loads(files[0].read_text(encoding="utf-8"))
    return {s["id"]: s for s in data.get("scenarios", [])}


def walk_specs(suite, out):
    for spec in suite.get("specs", []):
        out.append(spec)
    for child in suite.get("suites", []):
        walk_specs(child, out)


CTRL_RE = re.compile(r"[\x00-\x08\x0b\x0c\x0e-\x1f]")


def clean(msg):
    # Hapus ANSI + karakter kontrol (openpyxl menolaknya: IllegalCharacterError).
    return CTRL_RE.sub("", ANSI_RE.sub("", msg or "")).strip() or None


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    report_path, module = Path(sys.argv[1]), sys.argv[2]
    report = json.loads(report_path.read_text(encoding="utf-8"))
    meta = load_scenario_meta(module)
    env = parse_env_md()

    stats = report.get("stats", {})
    started = stats.get("startTime")
    started_dt = datetime.fromisoformat(started.replace("Z", "+00:00")) if started else datetime.now(timezone.utc)
    run_id = started_dt.astimezone().strftime("%Y%m%d-%H%M%S")
    duration_ms = stats.get("duration") or 0
    finished_dt = datetime.fromtimestamp(started_dt.timestamp() + duration_ms / 1000, tz=timezone.utc)

    specs = []
    for suite in report.get("suites", []):
        walk_specs(suite, specs)

    shot_dir = ROOT / "artifacts" / "screenshots" / run_id
    scenarios = []
    for spec in specs:
        m = SCN_RE.match(spec.get("title", ""))
        if not m:
            continue  # test non-skenario (mis. setup login)
        scn_id = m.group(1)
        src = meta.get(scn_id, {})
        tests = spec.get("tests", [])
        result = (tests[0].get("results") or [{}])[-1] if tests else {}
        raw_status = result.get("status", "skipped")
        status = STATUS_MAP.get(raw_status, "blocked")

        errors = result.get("errors") or ([result["error"]] if result.get("error") else [])
        error = clean(" | ".join(e.get("message", "") for e in errors)[:1000]) if errors else None

        notes = []
        blocked = False
        bug_candidate = None
        for t in tests:
            for a in t.get("annotations", []):
                if a.get("type") == "blocked":
                    blocked = True  # precondition gagal (docs/agent-guide.md): status blocked, bukan skipped
                if a.get("type") == "bugCandidate" and a.get("description"):
                    bug_candidate = a["description"].split(" ")[0]
                if a.get("description"):
                    prefix = "[skip] " if a.get("type") == "skip" else ("[blocked] " if a.get("type") == "blocked" else ("[bug-candidate] " if a.get("type") == "bugCandidate" else ""))
                    notes.append(prefix + a["description"])
        if blocked and status in ("skipped", "failed"):
            status = "blocked"

        # Kegagalan login dari fixture (tests/helpers/fixtures.js) = environment, bukan bug skenario.
        if error and ("Login OMS gagal" in error or "Login sudah gagal" in error or "Login portal Operator" in error):
            status = "blocked"

        screenshot = None
        for att in result.get("attachments", []):
            if att.get("name") == "screenshot" and att.get("path") and Path(att["path"]).exists():
                shot_dir.mkdir(parents=True, exist_ok=True)
                dest = shot_dir / f"{scn_id}.png"
                shutil.copyfile(att["path"], dest)
                screenshot = str(dest.relative_to(ROOT))
                break

        scenarios.append({
            "id": src.get("id", scn_id),
            "title": src.get("title", spec.get("title", "")),
            "category": src.get("category", ""),
            "priority": src.get("priority", ""),
            "screen": src.get("screen", ""),
            "requirements": src.get("requirements", []),
            "status": status,
            "durationSec": round((result.get("duration") or 0) / 1000, 1),
            "error": error,
            "screenshot": screenshot,
            "bugCandidate": bug_candidate,
            "notes": "; ".join(notes),
        })

    scenarios.sort(key=lambda s: s["id"])
    out = {
        "module": module,
        "runId": run_id,
        "startedAt": started_dt.isoformat(),
        "finishedAt": finished_dt.isoformat(),
        "environment": {**env, "executor": "playwright-script"},
        "scenarios": scenarios,
    }
    out_path = ROOT / "results" / f"{module}__{run_id}.json"
    out_path.write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")
    counts = {}
    for s in scenarios:
        counts[s["status"]] = counts.get(s["status"], 0) + 1
    print(f"{len(scenarios)} skenario -> {counts}", file=sys.stderr)
    print(out_path.relative_to(ROOT))


if __name__ == "__main__":
    main()
