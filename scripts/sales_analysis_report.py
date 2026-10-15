"""Laporan agregat order untuk mode --sales-analysis pada generate_report.py."""

import json
from collections import Counter, defaultdict
from datetime import date, datetime, timedelta
from pathlib import Path

from openpyxl import Workbook
from openpyxl.styles import Alignment, Font, PatternFill
from openpyxl.utils import get_column_letter
from openpyxl.worksheet.table import Table, TableStyleInfo


BLUE = "1F4E79"
GREEN = "E2F0D9"
STATUSES = ("done", "pending", "void", "bataltiket")
COUNT_HEADERS = ["Jumlah User", "Jumlah Order", "Selesai", "Pending", "Expired", "Tiket dibatalkan", "Status lain"]


def metrics(rows):
    statuses = Counter(r["status"] for r in rows)
    return [
        len({r["userHash"] for r in rows if r.get("userHash")}),
        len(rows),
        *(statuses[s] for s in STATUSES),
        sum(v for k, v in statuses.items() if k not in STATUSES),
    ]


def week_start(day):
    return day - timedelta(days=day.weekday())


def weekly(rows, year, end):
    groups = defaultdict(list)
    for r in rows:
        groups[week_start(r["day"])].append(r)
    start = date(year, 1, 1)
    end = min(end, date(year, 12, 31))
    monday = week_start(start)
    result = []
    while monday <= end:
        a, b = max(start, monday), min(end, monday + timedelta(days=6))
        iso = monday.isocalendar()
        result.append([
            year, f"{iso.year}-W{iso.week:02d}", a, b,
            "Parsial" if a != monday or b != monday + timedelta(days=6) else "Penuh",
            *metrics(groups[monday]),
        ])
        monday += timedelta(days=7)
    return result


def sheet(wb, name, headers, rows, date_columns=(), widths=None):
    ws = wb.create_sheet(name)
    ws.append(headers)
    for row in rows:
        ws.append(row)
    for c in ws[1]:
        c.font = Font(name="Arial", size=10, bold=True, color="FFFFFF")
        c.fill = PatternFill("solid", fgColor=BLUE)
        c.alignment = Alignment(wrap_text=True, vertical="center")
    ws.row_dimensions[1].height = 32
    for row in ws.iter_rows(min_row=2):
        for c in row:
            c.font = Font(name="Arial", size=10)
            c.alignment = Alignment(vertical="top")
            if isinstance(c.value, str):
                # Imported route labels are text, never spreadsheet formulas.
                c.data_type = "s"
            elif isinstance(c.value, (int, float)):
                c.number_format = "0" if headers[c.column - 1] in ("Tahun", "Bulan") else "#,##0"
        for index in date_columns:
            row[index - 1].number_format = "dd mmm yyyy"
    for index in range(1, len(headers) + 1):
        width = widths[index - 1] if widths else max(15, min(28, len(headers[index - 1]) + 3))
        ws.column_dimensions[get_column_letter(index)].width = width
    ws.freeze_panes = "A2"
    if rows:
        table = Table(displayName=f"T{len(wb.worksheets)}", ref=ws.dimensions)
        table.tableStyleInfo = TableStyleInfo(name="TableStyleMedium2", showRowStripes=True)
        ws.add_table(table)
    ws.sheet_view.showGridLines = False
    ws.sheet_properties.pageSetUpPr.fitToPage = True
    ws.page_setup.orientation = "landscape"
    ws.page_setup.paperSize = ws.PAPERSIZE_A4
    ws.page_setup.fitToWidth, ws.page_setup.fitToHeight = 1, 0
    ws.print_title_rows = "1:1"
    return ws


def generate_sales_analysis(input_path, report_dir):
    config = json.loads(input_path.read_text(encoding="utf-8"))
    if config.get("kind") != "sales-analysis":
        raise ValueError("Input harus memiliki kind sales-analysis.")
    source = json.loads(Path(config["source"]).read_text(encoding="utf-8"))
    routes = json.loads(Path(config["routes"]).read_text(encoding="utf-8"))
    if not source.get("complete") or not routes.get("complete"):
        raise ValueError("Snapshot order dan pemetaan rute harus lengkap.")
    if routes["source"] != config["source"]:
        raise ValueError("Pemetaan rute berasal dari snapshot berbeda.")
    years = (2025, 2026)
    raw = [r for r in source["orders"] if r.get("createdAt", "")[:4] in {str(y) for y in years}]
    if len({r["id"] for r in raw}) != len(raw):
        raise ValueError("Ada ID order ganda.")
    if set(routes["routes"]) != {str(r["id"]) for r in raw}:
        raise ValueError("Rute belum mencakup seluruh ID order target.")
    rows = []
    for r in raw:
        if r["testMarker"]:
            continue
        if not r.get("userHash"):
            raise ValueError("Ada order tanpa ID pembeli.")
        if r["userKind"] != "Pembeli Umum" or r["channel"].lower() != "online":
            raise ValueError("Ada order di luar cakupan user umum Online.")
        route = routes["routes"][str(r["id"])]
        rows.append({**r, "day": date.fromisoformat(r["createdAt"][:10]), **route})
    if not rows:
        raise ValueError("Tidak ada order pada periode target.")
    per_year = {year: [r for r in rows if r["day"].year == year] for year in years}
    end = max(date.fromisoformat(r["createdAt"][:10]) for r in raw)
    wb = Workbook()
    summary = wb.active
    summary.title = "Summary"
    summary.sheet_view.showGridLines = False
    summary.merge_cells("A1:I1")
    summary["A1"] = "Analisis User Umum dan Order — 2025 & 2026"
    summary["A1"].font = Font(name="Arial", size=18, bold=True, color=BLUE)
    metadata = [
        ("Cakupan", "Operator Pusat; Pembeli General + Online"),
        ("Dasar tanggal", "Tanggal pembuatan order, bukan tanggal keberangkatan"),
        ("Periode", f"1 Januari 2025–{end:%d-%m-%Y}; tahun 2026 belum satu tahun penuh"),
        ("Jumlah User", "Jumlah akun pembeli yang membuat order; setiap akun dihitung sekali dalam periode terkait"),
        ("Status", "Semua status order; rinciannya tersedia pada setiap tabel"),
        ("Data uji", "Order bertanda AUTOTEST dikeluarkan; data uji tanpa penanda dapat tetap tercakup"),
    ]
    for i, (label, text) in enumerate(metadata, 3):
        summary.cell(i, 1, label).font = Font(name="Arial", bold=True, size=10)
        summary.merge_cells(start_row=i, start_column=2, end_row=i, end_column=9)
        summary.cell(i, 2, text).alignment = Alignment(wrap_text=True)
        summary.row_dimensions[i].height = 30
    total_headers = ["Periode", "Jumlah User", "Jumlah Order", "Selesai", "Pending", "Expired", "Tiket dibatalkan", "Status lain", "Order AUTOTEST dikeluarkan"]
    for column, title in enumerate(total_headers, 1):
        summary.cell(10, column, title)
    summary_rows = []
    for year in years:
        excluded = sum(r["testMarker"] for r in raw if r["createdAt"].startswith(str(year)))
        summary_rows.append([str(year), *metrics(per_year[year]), excluded])
    summary_rows.append(["Gabungan 2025–2026", *metrics(rows), sum(r["testMarker"] for r in raw)])
    for i, row in enumerate(summary_rows, 11):
        for col, value in enumerate(row, 1):
            summary.cell(i, col, value)
        if i == 13:
            for c in summary[i]:
                c.fill = PatternFill("solid", fgColor=GREEN)
                c.font = Font(name="Arial", bold=True)
    summary.merge_cells("A15:I16")
    summary["A15"] = "Total user gabungan dihitung dari ID pembeli berbeda. User antartahun, minggu, bulan, dan rute tidak boleh dijumlahkan karena akun yang sama dapat muncul pada beberapa periode/rute."
    summary["A15"].alignment = Alignment(wrap_text=True, vertical="top")
    summary.row_dimensions[15].height = 32
    summary_rows_peak = []
    for year in years:
        weeks = weekly(per_year[year], year, end)
        assert sum(w[6] for w in weeks) == len(per_year[year])
        ws = sheet(wb, f"Mingguan {year}", ["Tahun", "Minggu ISO", "Mulai", "Selesai periode", "Cakupan minggu", *COUNT_HEADERS], weeks, (3, 4))
        peak = max(weeks, key=lambda w: (w[5], w[6]))
        summary_rows_peak.append([year, peak[2], peak[3], peak[5], peak[6]])
        for row in ws.iter_rows(min_row=2):
            if row[5].value == peak[5]:
                for c in row:
                    c.fill = PatternFill("solid", fgColor=GREEN)
    summary["A18"] = "Puncak mingguan berdasarkan jumlah user"
    summary["A18"].font = Font(name="Arial", bold=True, size=12, color=BLUE)
    for col, value in enumerate(["Tahun", "Mulai", "Selesai periode", "Jumlah User", "Jumlah Order"], 1):
        summary.cell(19, col, value)
    for index, values in enumerate(summary_rows_peak, 20):
        for col, value in enumerate(values, 1):
            summary.cell(index, col, value)
        summary.cell(index, 2).number_format = summary.cell(index, 3).number_format = "dd mmm yyyy"
    summary.merge_cells("A23:C23")
    summary["A23"] = "User pembuat order pada kedua tahun"
    summary["A23"].font = Font(name="Arial", bold=True, size=10)
    summary["D23"] = len(
        {r["userHash"] for r in per_year[2025]} & {r["userHash"] for r in per_year[2026]}
    )
    monthly = defaultdict(list)
    daily = defaultdict(list)
    route_groups = defaultdict(list)
    yearly_routes = defaultdict(list)
    weekly_routes = defaultdict(list)
    for r in rows:
        monthly[(r["day"].year, r["day"].month)].append(r)
        daily[r["day"]].append(r)
        route_key = (r["origin"], r["destination"])
        route_groups[route_key].append(r)
        yearly_routes[(r["day"].year, *route_key)].append(r)
        weekly_routes[(r["day"].year, week_start(r["day"]), *route_key)].append(r)
    month_rows = []
    for year in years:
        for month in range(1, (end.month if year == end.year else 12) + 1):
            group = monthly[(year, month)]
            month_rows.append([year, month, date(year, month, 1), *metrics(group)])
    assert sum(r[4] for r in month_rows) == len(rows)
    sheet(wb, "Bulanan", ["Tahun", "Bulan", "Awal bulan", *COUNT_HEADERS], month_rows, (3,))
    day_rows = []
    day = date(2025, 1, 1)
    while day <= end:
        day_rows.append([day.year, day, *metrics(daily[day])])
        day += timedelta(days=1)
    sheet(wb, "Harian", ["Tahun", "Tanggal order", *COUNT_HEADERS], day_rows, (2,))
    route_rows = [
        [origin, destination, *metrics(group)]
        for (origin, destination), group in sorted(route_groups.items(), key=lambda item: (-len(item[1]), item[0]))
    ]
    assert sum(r[3] for r in route_rows) == len(rows)
    sheet(wb, "Rute", ["Asal", "Tujuan", *COUNT_HEADERS], route_rows, widths=[30, 30, *([19] * len(COUNT_HEADERS))])
    route_year_rows = [
        [year, origin, destination, *metrics(group)]
        for (year, origin, destination), group in sorted(yearly_routes.items(), key=lambda item: (item[0][0], -len(item[1]), item[0][1:]))
    ]
    sheet(wb, "Rute per Tahun", ["Tahun", "Asal", "Tujuan", *COUNT_HEADERS], route_year_rows)
    route_week_rows = []
    for (year, monday, origin, destination), group in sorted(weekly_routes.items()):
        a, b = max(date(year, 1, 1), monday), min(date(year, 12, 31), end, monday + timedelta(days=6))
        route_week_rows.append([year, a, b, origin, destination, *metrics(group)])
    assert sum(r[6] for r in route_week_rows) == len(rows)
    sheet(wb, "Rute Mingguan", ["Tahun", "Mulai", "Selesai periode", "Asal", "Tujuan", *COUNT_HEADERS], route_week_rows, (2, 3))
    unavailable = sum("tidak tersedia" in r["origin"] or "tidak tersedia" in r["destination"] for r in rows)
    notes = [
        ["Sumber", "Daftar Order aplikasi; filter Pembeli General dan Online pada Operator Pusat"],
        ["Snapshot order dimulai", source["startedAt"]],
        ["Snapshot order selesai", source["finishedAt"]],
        ["Pemetaan rute dimulai", routes["startedAt"]],
        ["Pemetaan rute selesai", routes["finishedAt"]],
        ["Penggabungan", "Rute dicocokkan dengan ID/kode order, hash ID pembeli, dan tanggal order pada snapshot"],
        ["Jumlah User", "Jumlah akun pembeli yang membuat order pada periode/rute terkait. Akun yang membuat beberapa order tetap dihitung satu user dalam kelompok tersebut."],
        ["Minggu", "Senin–Minggu. Minggu lintas tahun dibatasi pada tahun masing-masing. Awal/akhir cakupan dapat parsial."],
        ["Batas waktu", f"2025 penuh; 2026 hanya sampai {end:%d-%m-%Y}. Jam mengikuti tampilan aplikasi, tanpa konversi zona waktu."],
        ["Jumlah Order", "Satu ID order dihitung satu kali; semua status disertakan. Order bukan jumlah tiket/penumpang."],
        ["Rute", "Asal (pol) → tujuan (pod) pada order. Arah sebaliknya dihitung sebagai rute berbeda. Kode pelabuhan dipertahankan; kota sama dengan kode berbeda tidak digabung."],
        ["Rute tidak tersedia", unavailable],
        ["Data uji", "Order dengan AUTOTEST pada nama pembeli/pemesan, voyage, atau nama penumpang dikeluarkan; penanda tidak menjamin semua data uji teridentifikasi."],
        ["Penjumlahan", "Jumlah order antarperiode/rute dapat dijumlahkan; jumlah user antarperiode/rute tidak dapat dijumlahkan karena akun yang sama dapat muncul kembali."],
        ["Akses dan concurrency", "Workbook menghitung pembuat order. Jumlah pengunjung dan pengguna bersamaan memerlukan log akses/sesi."],
        ["Validasi", f"{len(raw):,} order mentah dipetakan ke rute; {len(rows):,} order setelah penyaringan; ID order tidak ganda."],
    ]
    ws_notes = sheet(wb, "Metodologi", ["Keterangan", "Definisi / nilai"], notes, widths=[31, 110])
    for row in ws_notes.iter_rows(min_row=2):
        row[1].alignment = Alignment(wrap_text=True, vertical="top")
        ws_notes.row_dimensions[row[0].row].height = 42
    for row_index in (10, 19):
        for c in summary[row_index]:
            if c.value is not None:
                c.font = Font(name="Arial", color="FFFFFF", bold=True)
                c.fill = PatternFill("solid", fgColor=BLUE)
                c.alignment = Alignment(wrap_text=True)
        summary.row_dimensions[row_index].height = 34
    for index in range(1, 10):
        summary.column_dimensions[get_column_letter(index)].width = 23 if index == 1 else 19
    summary.freeze_panes = "B11"
    report_dir.mkdir(exist_ok=True)
    output = report_dir / f"analisis-user-umum-2025-2026__{datetime.now():%Y%m%d-%H%M%S}.xlsx"
    if output.exists():
        raise FileExistsError(output)
    wb.save(output)
    return output
