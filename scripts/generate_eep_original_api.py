#!/usr/bin/env python3
from __future__ import annotations

"""
Generator fuer `lua/LUA/ce/hub/eep/EepOriginalApi.d.lua`.

Referenz fuer den semantischen Tabellenaufbau im PDF:
`lua/LUA/ce/hub/eep/Aufbau_Lua_Manual.md`

Wichtige Layout-Regeln:
- Funktionsbloecke haben drei Spalten.
- Spalte 1 und 2 bilden im Kopf gemeinsam den Funktionsnamen.
- Spalte 3 enthaelt oben das Signaturbeispiel und darunter den Beispielblock.
- `Parameter`, `Rueckgabewerte` und `Voraussetzung` haben links Label und Mitte Inhalt;
  rechts liegt derselbe verbundene Beispielblock.
- `Zweck` und `Bemerkungen` werden aus den layoutbasierten Feldflaechen gelesen,
  nicht als freie Beispielzeilen.
"""

import difflib
import re
import textwrap
import unicodedata
from dataclasses import dataclass, field
from functools import lru_cache
from pathlib import Path
from statistics import median


ROOT = Path(__file__).resolve().parents[1]
MANUAL = ROOT / "Lua_manual.pdf"
OUTPUT = ROOT / "lua" / "LUA" / "ce" / "hub" / "eep" / "EepOriginalApi.d.lua"
LUA_FORMAT_CONFIG = ROOT / "lua-format.conf"
PDFMINER_ROW_TOLERANCE = 4.0
HEADER_BAND_Y_TOLERANCE = 3.0

ENTRY_NAME_RE = re.compile(r"^(EEP[A-Za-z0-9_]+|clearlog|print)(\s*\(\s*\))?$")
FIELD_LABELS = ("Parameter", "Rueckgabewerte", "Voraussetzung", "Zweck", "Bemerkungen")
FIELD_SET = set(FIELD_LABELS)
RETURN_BULLET_RE = re.compile(
    r"^(?:Der\s+)?(?:(?:\(\d+\.\)|\d+\.)\s+)?(?:\([^)]+\)\s+)?Rueckgabewert\b",
    re.IGNORECASE,
)
PARAM_BULLET_RE = re.compile(
    r"^(?:Der|Im|Als|Ueber\s+den)\s+(?:optionale[nr]?\s+)?(?:\d+\.\s+)?Parameter\b",
    re.IGNORECASE,
)
PARAM_RANGE_RE = re.compile(r"^Die\s+Parameter\s+(\d+)\s*[–-]\s*(\d+)\b", re.IGNORECASE)
COUNT_WORD_MAP = {
    "keine": 0,
    "keiner": 0,
    "eine": 1,
    "einer": 1,
    "einen": 1,
    "zwei": 2,
    "drei": 3,
    "vier": 4,
    "fuenf": 5,
    "sechs": 6,
    "sieben": 7,
}


def read_wrap_width() -> int:
    try:
        config_text = LUA_FORMAT_CONFIG.read_text(encoding="utf-8")
    except OSError:
        return 118
    match = re.search(r"(?m)^column_limit:\s*(\d+)\s*$", config_text)
    return int(match.group(1)) if match else 118


WRAP_WIDTH = read_wrap_width()

KNOWN_COUNT_OVERRIDES: dict[tuple[str, str], list[int]] = {
    ("EEPRollingstockGetHookPosition", "Parameter"): [2],
    ("EEPRollingstockSetHorn", "Parameter"): [2],
    ("EEPGetFogIntensity", "Rueckgabewerte"): [1],
}

ASCII_TRANSLATION = str.maketrans(
    {
        "Ä": "Ae",
        "Ö": "Oe",
        "Ü": "Ue",
        "ä": "ae",
        "ö": "oe",
        "ü": "ue",
        "ß": "ss",
        "ç": "c",
        "·": "-",
    }
)


def ascii_text(value: str) -> str:
    value = value.translate(ASCII_TRANSLATION)
    return unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")


@dataclass
class Entry:
    name: str
    callable: bool
    signature_example: str = ""
    fields: dict[str, list[str]] = field(default_factory=dict)
    examples: list[str] = field(default_factory=list)

    def add_field(self, field_name: str, value: str) -> None:
        value = clean_text(value)
        if not value:
            return
        bucket = self.fields.setdefault(field_name, [])
        if value not in bucket:
            bucket.append(value)

    def add_example(self, value: str) -> None:
        value = normalize_example(value)
        if not value:
            return
        if not self.examples or self.examples[-1] != value:
            self.examples.append(value)

    def append_field_fragment(self, field_name: str, value: str) -> None:
        value = clean_text(value)
        if not value:
            return
        bucket = self.fields.setdefault(field_name, [])
        if bucket:
            bucket[-1] = clean_text(f"{bucket[-1]} {value}")
        else:
            bucket.append(value)


@dataclass
class TableRow:
    label: str = ""
    content: str = ""
    example: str = ""
    y: float = 0.0
    content_x0: float | None = None
    example_x0: float | None = None

    def text(self) -> str:
        return clean_text(" ".join(part for part in (self.label, self.content, self.example) if part))


@dataclass(frozen=True)
class HeaderBand:
    page_no: int
    y_bottom: float
    y_top: float
    split_x: float


@dataclass(frozen=True)
class ExampleBand:
    page_no: int
    y_bottom: float
    y_top: float
    x0: float
    x1: float


@dataclass(frozen=True)
class FieldBand:
    page_no: int
    y_bottom: float
    y_top: float
    label_x1: float
    content_x0: float
    content_x1: float


@dataclass(frozen=True)
class RectCell:
    page_no: int
    y_bottom: float
    y_top: float
    x0: float
    x1: float

    @property
    def width(self) -> float:
        return self.x1 - self.x0

    @property
    def height(self) -> float:
        return self.y_top - self.y_bottom


@dataclass(frozen=True)
class RectBand:
    page_no: int
    y_bottom: float
    y_top: float
    cells: tuple[RectCell, ...]


def clean_text(value: str) -> str:
    value = value.replace("\x0c", " ").replace("\t", " ").strip()
    value = value.replace("•", "-")
    value = value.replace("“", '"').replace("”", '"')
    value = value.replace("„", '"').replace("«", '"').replace("»", '"')
    value = value.replace("’", "'").replace("‘", "'")
    value = value.replace("–", "-").replace("—", "-")
    value = re.sub(r"\s+", " ", value)
    value = value.replace("Rueckruf", "Rueckruf")
    value = value.replace("Plug-in", "Plugin")
    value = value.replace("Plug-In", "Plugin")
    return ascii_text(value)


def normalize_example(value: str) -> str:
    value = value.replace("\x0c", " ").rstrip()
    value = re.sub(r"\s+", " ", value).strip()
    value = ascii_text(value)
    if value == "end":
        return "end"
    return value


def split_parts(raw_line: str) -> list[str]:
    return [clean_text(part) for part in re.split(r"\s{2,}", raw_line.rstrip()) if clean_text(part)]


def join_parts(parts: list[str]) -> str:
    return clean_text(" ".join(parts))


def is_count_word(value: str) -> bool:
    return clean_text(value).lower() in {
        *COUNT_WORD_MAP.keys(),
        "einer oder keiner",
        "einer oder zwei",
        "zwei oder drei",
        "drei oder vier",
        "mehrere",
        "sechs oder sieben",
    }


def parse_count_candidates(values: list[str]) -> list[int]:
    text = clean_text(" ".join(values)).lower()
    words = re.findall(r"[a-z]+", text)
    candidates = [COUNT_WORD_MAP[word] for word in words if word in COUNT_WORD_MAP]
    return sorted(set(candidates))


def count_candidates_for_entry(entry: Entry, field_name: str) -> list[int]:
    override = KNOWN_COUNT_OVERRIDES.get((entry.name, field_name))
    if override is not None:
        return override
    return parse_count_candidates(entry.fields.get(field_name, []))


def looks_like_complete_version(value: str) -> bool:
    text = clean_text(value).strip(";,.")
    return bool(re.fullmatch(r"EEP\s+\d+(?:\.\d+)?(?:\s+Plugin\s*\d+)?", text))


def looks_like_version_piece(value: str) -> bool:
    text = clean_text(value).strip(";,.")
    return bool(
        looks_like_complete_version(text)
        or re.fullmatch(r"-\s*Plugin\s*\d+", text)
        or re.fullmatch(r"\d+;?", text)
        or re.fullmatch(r"EEP\s+\d+(?:\.\d+)?\s+Plugin", text)
    )


def looks_like_count_fragment(value: str) -> bool:
    text = clean_text(value).lower().strip(";,")
    if is_count_word(text):
        return True
    return bool(re.fullmatch(r"(keine|keiner|eine|einer|einen|zwei|drei|vier|fünf|sechs|sieben|oder)+(\s+(keine|keiner|eine|einer|einen|zwei|drei|vier|fünf|sechs|sieben|oder))*", text))


def merge_prefix_parts(parts: list[str]) -> list[str]:
    merged: list[str] = []
    index = 0
    while index < len(parts):
        current = clean_text(parts[index])
        next_part = clean_text(parts[index + 1]) if index + 1 < len(parts) else ""
        if current in {"- Plugin", "-Plugin"} and re.fullmatch(r"\d+;?", next_part):
            merged.append(f"- Plugin {next_part.strip(';')}")
            index += 2
            continue
        if re.fullmatch(r"EEP\s+\d+(?:\.\d+)?\s+Plugin", current) and re.fullmatch(r"\d+;?", next_part):
            merged.append(f"{current} {next_part.strip(';')}")
            index += 2
            continue
        if looks_like_count_fragment(current) and looks_like_count_fragment(next_part):
            merged.append(f"{current} {next_part}".strip())
            index += 2
            continue
        merged.append(current)
        index += 1
    return merged


def is_index_start(line: str) -> bool:
    stripped = clean_text(line)
    return stripped.startswith("Stichwortregister") and "Inhaltsverzeichnis" not in stripped


def is_noise(line: str) -> bool:
    stripped = clean_text(line)
    if not stripped:
        return True
    if stripped.startswith("Inhaltsverzeichnis"):
        return True
    if stripped.startswith("EEP-spezifische Lua-Variablen und -Funktionen"):
        return True
    if stripped.startswith("weitere ") and stripped.endswith("Funktionen"):
        return True
    if stripped == "Fortsetzung nächste Seite":
        return True
    if re.fullmatch(r"\d+\s+.*Funktionen", stripped):
        return True
    if re.fullmatch(r"\d+\s+.*Variablen", stripped):
        return True
    return False


def is_toc_entry(line: str) -> bool:
    stripped = clean_text(line)
    if not stripped:
        return False
    return bool(
        re.fullmatch(
            r"(EEP[A-Za-z0-9_]+|clearlog|print)\s*\(\)\s+.+\s+\d+(?:-\d+|—\d+)$",
            stripped,
        )
    )


def is_block_terminator(line: str) -> bool:
    stripped = clean_text(line)
    if is_index_start(stripped):
        return True
    if stripped.startswith("Inhaltsverzeichnis"):
        return True
    if stripped.startswith("EEP-spezifische Lua-Variablen und -Funktionen"):
        return True
    if stripped.startswith("weitere ") and stripped.endswith("Funktionen"):
        return True
    if re.fullmatch(r"\d+\s+.*Funktionen", stripped):
        return True
    if re.fullmatch(r"\d+\s+.*Variablen", stripped):
        return True
    if is_toc_entry(stripped):
        return True
    return False


def kmeans_1d(values: list[float], k: int, iterations: int = 12) -> list[float]:
    if not values:
        return []
    unique_values = sorted(set(values))
    if len(unique_values) <= k:
        return [float(value) for value in unique_values]
    centers = [unique_values[round(index * (len(unique_values) - 1) / (k - 1))] for index in range(k)]
    for _ in range(iterations):
        clusters: list[list[float]] = [[] for _ in centers]
        for value in values:
            best_index = min(range(len(centers)), key=lambda index: abs(value - centers[index]))
            clusters[best_index].append(value)
        new_centers = []
        for index, cluster in enumerate(clusters):
            if cluster:
                new_centers.append(sum(cluster) / len(cluster))
            else:
                new_centers.append(centers[index])
        if all(abs(new_centers[index] - centers[index]) < 0.5 for index in range(len(centers))):
            centers = new_centers
            break
        centers = new_centers
    return sorted(centers)


@lru_cache(maxsize=1)
def extract_rect_bands() -> dict[int, list[RectBand]]:
    try:
        import fitz
    except ImportError as exc:
        raise RuntimeError("PyMuPDF is required for color-assisted layout extraction") from exc

    if not MANUAL.exists():
        raise FileNotFoundError(f"manual not found: {MANUAL}")

    bands_by_page: dict[int, list[RectBand]] = {}
    with fitz.open(MANUAL) as document:
        for page_no in range(document.page_count):
            page = document[page_no]
            page_height = float(page.rect.height)
            cells: list[RectCell] = []
            for drawing in page.get_drawings():
                rect = drawing.get("rect")
                fill = drawing.get("fill")
                if rect is None or fill is None:
                    continue
                x0, y0, x1, y1 = (float(rect.x0), float(rect.y0), float(rect.x1), float(rect.y1))
                width = x1 - x0
                height = y1 - y0
                if width < 40 or height < 8 or height > 140:
                    continue
                cells.append(
                    RectCell(
                        page_no=page_no,
                        y_bottom=page_height - y1,
                        y_top=page_height - y0,
                        x0=x0,
                        x1=x1,
                    )
                )

            grouped: list[list[RectCell]] = []
            for cell in sorted(cells, key=lambda value: (-value.y_top, value.x0, -value.width)):
                if not grouped or abs(grouped[-1][0].y_top - cell.y_top) > HEADER_BAND_Y_TOLERANCE or abs(grouped[-1][0].y_bottom - cell.y_bottom) > HEADER_BAND_Y_TOLERANCE:
                    grouped.append([cell])
                else:
                    grouped[-1].append(cell)

            page_bands: list[RectBand] = []
            for group in grouped:
                filtered: list[RectCell] = []
                for cell in sorted(group, key=lambda value: (value.x0, -value.width)):
                    contained = any(
                        other is not cell
                        and other.x0 <= cell.x0 + 1.0
                        and other.x1 >= cell.x1 - 1.0
                        and other.y_bottom <= cell.y_bottom + 1.0
                        and other.y_top >= cell.y_top - 1.0
                        and (other.width > cell.width + 8 or other.height > cell.height + 4)
                        for other in group
                    )
                    if contained:
                        continue
                    if filtered and abs(filtered[-1].x0 - cell.x0) <= 2.0 and abs(filtered[-1].x1 - cell.x1) <= 2.0:
                        if cell.width * cell.height > filtered[-1].width * filtered[-1].height:
                            filtered[-1] = cell
                        continue
                    filtered.append(cell)
                if filtered:
                    page_bands.append(
                        RectBand(
                            page_no=page_no,
                            y_bottom=min(cell.y_bottom for cell in filtered),
                            y_top=max(cell.y_top for cell in filtered),
                            cells=tuple(sorted(filtered, key=lambda value: value.x0)),
                        )
                    )
            if page_bands:
                bands_by_page[page_no] = page_bands
    return bands_by_page


@lru_cache(maxsize=1)
def extract_header_bands() -> dict[int, list[HeaderBand]]:
    bands_by_page: dict[int, list[HeaderBand]] = {}
    for page_no, rect_bands in extract_rect_bands().items():
        page_bands: list[HeaderBand] = []
        for band in rect_bands:
            if len(band.cells) != 2:
                continue
            left_cell, right_cell = band.cells
            if left_cell.x0 > 100 or right_cell.x1 < 500:
                continue
            if left_cell.width < 120 or right_cell.width < 180:
                continue
            page_bands.append(
                HeaderBand(
                    page_no=page_no,
                    y_bottom=band.y_bottom,
                    y_top=band.y_top,
                    split_x=right_cell.x0,
                )
            )
        if page_bands:
            bands_by_page[page_no] = sorted(page_bands, key=lambda band: -band.y_top)
    return bands_by_page


@lru_cache(maxsize=1)
def extract_example_bands() -> dict[int, list[ExampleBand]]:
    header_bands = extract_header_bands()
    bands_by_page: dict[int, list[ExampleBand]] = {}
    for page_no, rect_bands in extract_rect_bands().items():
        page_headers = header_bands.get(page_no, [])
        page_bands: list[ExampleBand] = []
        for band in rect_bands:
            if len(band.cells) != 1:
                continue
            cell = band.cells[0]
            if cell.width < 180 or cell.height < 40 or cell.x1 < 500:
                continue
            matching_header = next(
                (
                    header
                    for header in page_headers
                    if abs(header.split_x - cell.x0) <= 24 and 0 <= header.y_bottom - cell.y_top <= 12
                ),
                None,
            )
            if matching_header is None:
                continue
            page_bands.append(
                ExampleBand(
                    page_no=page_no,
                    y_bottom=band.y_bottom,
                    y_top=band.y_top,
                    x0=cell.x0,
                    x1=cell.x1,
                )
            )
        if page_bands:
            bands_by_page[page_no] = sorted(page_bands, key=lambda band: -band.y_top)
    return bands_by_page


@lru_cache(maxsize=1)
def extract_field_bands() -> dict[int, list[FieldBand]]:
    bands_by_page: dict[int, list[FieldBand]] = {}
    for page_no, rect_bands in extract_rect_bands().items():
        page_bands: list[FieldBand] = []
        for band in rect_bands:
            if len(band.cells) != 2:
                continue
            left_cell, middle_cell = band.cells
            if left_cell.x0 > 100 or left_cell.width < 60 or left_cell.width > 110:
                continue
            if middle_cell.x0 < left_cell.x1 - 6 or middle_cell.x1 > 320 or middle_cell.width < 35 or middle_cell.width > 120:
                continue
            page_bands.append(
                FieldBand(
                    page_no=page_no,
                    y_bottom=band.y_bottom,
                    y_top=band.y_top,
                    label_x1=left_cell.x1,
                    content_x0=middle_cell.x0,
                    content_x1=middle_cell.x1,
                )
            )
        if page_bands:
            bands_by_page[page_no] = sorted(page_bands, key=lambda band: -band.y_top)
    return bands_by_page


def header_band_for_row(row: list[dict[str, object]], bands_by_page: dict[int, list[HeaderBand]]) -> HeaderBand | None:
    if not row:
        return None
    page_no = int(row[0].get("page_no", -1))
    row_y = max(float(item["y"]) for item in row)
    for band in bands_by_page.get(page_no, []):
        if band.y_bottom - HEADER_BAND_Y_TOLERANCE <= row_y <= band.y_top + HEADER_BAND_Y_TOLERANCE:
            return band
    return None


def example_band_for_row(row: list[dict[str, object]], bands_by_page: dict[int, list[ExampleBand]]) -> ExampleBand | None:
    if not row:
        return None
    page_no = int(row[0].get("page_no", -1))
    row_y = max(float(item["y"]) for item in row)
    for band in bands_by_page.get(page_no, []):
        if band.y_bottom - HEADER_BAND_Y_TOLERANCE <= row_y <= band.y_top + HEADER_BAND_Y_TOLERANCE:
            return band
    return None


def field_band_for_row(row: list[dict[str, object]], bands_by_page: dict[int, list[FieldBand]]) -> FieldBand | None:
    if not row:
        return None
    page_no = int(row[0].get("page_no", -1))
    row_y = max(float(item["y"]) for item in row)
    for band in bands_by_page.get(page_no, []):
        if band.y_bottom - HEADER_BAND_Y_TOLERANCE <= row_y <= band.y_top + HEADER_BAND_Y_TOLERANCE:
            return band
    return None


def extract_pdfminer_rows() -> list[list[dict[str, object]]]:
    try:
        from pdfminer.high_level import extract_pages
        from pdfminer.layout import LTTextContainer, LTTextLine
    except ImportError as exc:
        raise RuntimeError("pdfminer.six is required for the layout extractor") from exc

    if not MANUAL.exists():
        raise FileNotFoundError(f"manual not found: {MANUAL}")

    rows: list[list[dict[str, object]]] = []
    for page_no, page in enumerate(extract_pages(str(MANUAL))):
        items: list[dict[str, object]] = []
        for element in page:
            if not isinstance(element, LTTextContainer):
                continue
            for line in element:
                if not isinstance(line, LTTextLine):
                    continue
                text = clean_text(line.get_text().replace("\n", " "))
                if not text:
                    continue
                items.append({"page_no": page_no, "y": float(line.y0), "x0": float(line.x0), "text": text})
        items.sort(key=lambda item: (-float(item["y"]), float(item["x0"])))
        grouped_rows: list[dict[str, object]] = []
        for item in items:
            y = float(item["y"])
            if not grouped_rows or abs(float(grouped_rows[-1]["y"]) - y) > PDFMINER_ROW_TOLERANCE:
                grouped_rows.append({"y": y, "items": [item]})
                continue
            grouped_rows[-1]["items"].append(item)
            grouped_rows[-1]["y"] = max(float(grouped_rows[-1]["y"]), y)
        for row in grouped_rows:
            rows.append(sorted(row["items"], key=lambda part: float(part["x0"])))
    return rows


def infer_layout_boundaries(rows: list[list[dict[str, object]]]) -> tuple[float, float, float]:
    label_positions = [
        float(item["x0"])
        for row in rows
        for item in row
        if str(item["text"]) in FIELD_SET or is_entry_start(str(item["text"]))
    ]
    label_center = median(label_positions) if label_positions else 76.8
    body_positions = [
        float(item["x0"])
        for row in rows
        for item in row
        if label_center + 20 <= float(item["x0"]) <= 360
    ]
    body_centers = kmeans_1d(body_positions, 3)
    content_center = body_centers[0] if body_centers else label_center + 90
    example_center = body_centers[1] if len(body_centers) > 1 else content_center + 90
    label_boundary = (label_center + content_center) / 2
    example_boundary = (content_center + example_center) / 2
    gap_threshold = max(24.0, (example_boundary - content_center) * 0.75)
    return label_boundary, example_boundary, gap_threshold


def render_layout_row(
    row: list[dict[str, object]],
    label_boundary: float,
    example_boundary: float,
    gap_threshold: float,
    bands_by_page: dict[int, list[HeaderBand]] | None = None,
    example_bands_by_page: dict[int, list[ExampleBand]] | None = None,
    field_bands_by_page: dict[int, list[FieldBand]] | None = None,
) -> TableRow:
    label_items: list[str] = []
    body_items: list[dict[str, object]] = []
    header_band = header_band_for_row(row, bands_by_page or {})
    example_band = example_band_for_row(row, example_bands_by_page or {})
    field_band = field_band_for_row(row, field_bands_by_page or {})
    for item in row:
        active_label_boundary = field_band.label_x1 if field_band is not None else label_boundary
        if not body_items and float(item["x0"]) < active_label_boundary:
            label_items.append(str(item["text"]))
        else:
            body_items.append(item)

    label_text = clean_text(" ".join(label_items))
    if not body_items:
        return TableRow(label=label_text)

    content_items: list[dict[str, object]] = []
    example_items: list[dict[str, object]] = []

    if header_band is not None:
        if label_text and is_entry_start(label_text):
            content_items = [item for item in body_items if float(item["x0"]) < header_band.split_x]
            example_items = [item for item in body_items if float(item["x0"]) >= header_band.split_x]
        else:
            example_items = body_items
    elif example_band is not None:
        content_items = [item for item in body_items if float(item["x0"]) < example_band.x0]
        example_items = [item for item in body_items if float(item["x0"]) >= example_band.x0]
        if not example_items and body_items and any(float(item["x0"]) >= example_boundary for item in body_items):
            example_items = [item for item in body_items if float(item["x0"]) >= example_boundary]
            content_items = [item for item in body_items if float(item["x0"]) < example_boundary]
    elif is_entry_start(label_text):
        example_items = body_items
    elif len(body_items) == 1:
        body_text = str(body_items[0]["text"])
        body_x = float(body_items[0]["x0"])
        if label_text in {"Zweck", "Bemerkungen"}:
            content_items = body_items
        elif label_text == "Voraussetzung":
            if looks_like_version_piece(body_text):
                content_items = body_items
            elif body_x >= example_boundary or is_example_start(body_text) or body_text.startswith("--"):
                example_items = body_items
            else:
                content_items = body_items
        elif label_text in {"Parameter", "Rueckgabewerte"} and (
            looks_like_count_fragment(body_text) or looks_like_version_piece(body_text)
        ):
            content_items = body_items
        elif body_x < example_boundary:
            content_items = body_items
        else:
            example_items = body_items
    else:
        gaps = [float(body_items[index + 1]["x0"]) - float(body_items[index]["x0"]) for index in range(len(body_items) - 1)]
        largest_gap = max(gaps)
        split_index = gaps.index(largest_gap) + 1
        if largest_gap >= gap_threshold:
            content_items = body_items[:split_index]
            example_items = body_items[split_index:]
        else:
            content_items = [item for item in body_items if float(item["x0"]) < example_boundary]
            example_items = [item for item in body_items if float(item["x0"]) >= example_boundary]
            if not content_items and label_text in {"Zweck", "Bemerkungen", "Voraussetzung", "Parameter", "Rueckgabewerte"}:
                content_items = body_items
                example_items = []

    columns = [
        label_text,
        clean_text(" ".join(str(item["text"]) for item in content_items)),
        clean_text(" ".join(str(item["text"]) for item in example_items)),
    ]
    return TableRow(
        label=columns[0],
        content=columns[1],
        example=columns[2],
        y=max(float(item["y"]) for item in row),
        content_x0=min((float(item["x0"]) for item in content_items), default=None),
        example_x0=min((float(item["x0"]) for item in example_items), default=None),
    )


def layout_table_rows() -> list[TableRow]:
    rows = extract_pdfminer_rows()
    bands_by_page = extract_header_bands()
    example_bands_by_page = extract_example_bands()
    field_bands_by_page = extract_field_bands()
    label_boundary, example_boundary, gap_threshold = infer_layout_boundaries(rows)
    table_rows = [
        render_layout_row(
            row,
            label_boundary,
            example_boundary,
            gap_threshold,
            bands_by_page,
            example_bands_by_page,
            field_bands_by_page,
        )
        for row in rows
    ]
    start_index = 0
    for index, row in enumerate(table_rows):
        if row.text() == "EEPVer":
            start_index = index
            break

    trimmed: list[TableRow] = []
    for row in table_rows[start_index:]:
        if is_index_start(row.text()):
            break
        trimmed.append(row)
    return [row for row in trimmed if not is_layout_navigation_row(row)]


def is_layout_navigation_row(row: TableRow) -> bool:
    text = row.text()
    if clean_text(row.label) == "Inhaltsverzeichnis":
        return True
    if text in {"EEP-spezifische Lua-Variablen und -Funktionen", "Stichwortregister"}:
        return True
    return False


def normalize_layout_rows(rows: list[TableRow]) -> list[TableRow]:
    normalized: list[TableRow] = []
    index = 0
    while index < len(rows):
        row = TableRow(
            label=clean_text(rows[index].label),
            content=clean_text(rows[index].content),
            example=normalize_example(rows[index].example),
            y=rows[index].y,
            content_x0=rows[index].content_x0,
            example_x0=rows[index].example_x0,
        )

        for field_name in FIELD_LABELS:
            if row.label.startswith(f"{field_name} ") and not row.content:
                row = TableRow(
                    label=field_name,
                    content=clean_text(row.label[len(field_name) :]),
                    example=row.example,
                    y=row.y,
                    content_x0=row.content_x0,
                    example_x0=row.example_x0,
                )
                break

        next_row = rows[index + 1] if index + 1 < len(rows) else None
        if next_row is not None:
            next_label = clean_text(next_row.label)
            next_content = clean_text(next_row.content)
            next_example = normalize_example(next_row.example)

            if is_entry_start_row(row) and not row.example and not next_label and not next_content and next_example:
                row = TableRow(
                    label=row.label,
                    content=row.content,
                    example=next_example,
                    y=row.y,
                    content_x0=row.content_x0,
                    example_x0=next_row.example_x0,
                )
                index += 1
                next_row = rows[index + 1] if index + 1 < len(rows) else None
                if next_row is not None:
                    next_label = clean_text(next_row.label)
                    next_content = clean_text(next_row.content)
                    next_example = normalize_example(next_row.example)

            if (
                not row.label
                and row.content
                and next_label in FIELD_SET
                and not next_content
                and not next_example
            ):
                row = TableRow(
                    label=next_label,
                    content=row.content,
                    example=row.example,
                    y=row.y,
                    content_x0=row.content_x0,
                    example_x0=row.example_x0,
                )
                index += 1
                next_row = rows[index + 1] if index + 1 < len(rows) else None

            elif (
                row.label in FIELD_SET
                and not row.content
                and not row.example
                and not next_label
                and next_content
                and not next_example
            ):
                row = TableRow(
                    label=row.label,
                    content=next_content,
                    example="",
                    y=row.y,
                    content_x0=next_row.content_x0,
                    example_x0=None,
                )
                index += 1
                next_row = rows[index + 1] if index + 1 < len(rows) else None

            elif (
                not row.label
                and row.content
                and looks_like_version_piece(row.content)
                and next_label == "Voraussetzung"
                and next_content
                and not looks_like_version_piece(next_content)
            ):
                merged_example = clean_text(" ".join(part for part in (row.example, next_content, next_example) if part))
                row = TableRow(
                    label="Voraussetzung",
                    content=row.content,
                    example=merged_example,
                    y=row.y,
                    content_x0=row.content_x0,
                    example_x0=next_row.content_x0 if next_content else next_row.example_x0,
                )
                index += 1
                next_row = rows[index + 1] if index + 1 < len(rows) else None

        if (
            normalized
            and normalized[-1].label == "Voraussetzung"
            and row.label in {"Zweck", "Bemerkungen"}
            and row.content
            and looks_like_version_piece(row.content)
        ):
            row = TableRow(
                label="",
                content=row.content,
                example=row.example,
                y=row.y,
                content_x0=row.content_x0,
                example_x0=row.example_x0,
            )

        if normalized:
            previous = normalized[-1]
            if is_entry_start_row(previous) and is_entry_start_row(row) and entry_name_from_row(previous) == entry_name_from_row(row):
                if row.example:
                    previous.example = clean_text(f"{previous.example} {row.example}") if previous.example else row.example
                if row.content and not is_entry_start(row.content):
                    previous.example = clean_text(f"{previous.example} {row.content}") if previous.example else row.content
                normalized[-1] = previous
                index += 1
                continue

        normalized.append(row)
        index += 1
    return normalize_spanning_field_rows(normalize_example_span_rows(normalize_entry_header_rows(normalized)))


def split_embedded_entry_example(row: TableRow) -> TableRow:
    label = clean_text(row.label)
    if row.content or row.example or not label:
        return row
    match = re.match(r"^((?:EEP[A-Za-z0-9_]+|clearlog|print)\s*\(\))\s+(.+)$", label)
    if not match:
        return row
    entry_label = clean_text(match.group(1))
    example = clean_text(match.group(2))
    if not is_entry_start(entry_label):
        return row
    return TableRow(
        label=entry_label,
        content="",
        example=normalize_example(example),
        y=row.y,
        content_x0=None,
        example_x0=row.content_x0 or row.example_x0,
    )


def normalize_entry_header_rows(rows: list[TableRow]) -> list[TableRow]:
    normalized: list[TableRow] = []
    index = 0
    while index < len(rows):
        row = split_embedded_entry_example(rows[index])
        if not is_entry_start_row(row):
            normalized.append(row)
            index += 1
            continue

        entry_name = entry_name_from_row(row)
        header_examples: list[str] = [row.example] if row.example else []
        header_example_x0 = row.example_x0
        next_index = index + 1
        while next_index < len(rows):
            next_row = split_embedded_entry_example(rows[next_index])
            next_label = clean_text(next_row.label)
            if next_label in FIELD_SET or is_block_terminator_row(next_row):
                break
            next_entry_name = entry_name_from_row(next_row)
            if (
                is_entry_start_row(next_row)
                and next_entry_name
                and next_entry_name != entry_name
                and not are_similar_entry_names(entry_name, next_entry_name)
            ):
                break
            if is_entry_start_row(next_row) and (
                next_entry_name == entry_name or are_similar_entry_names(entry_name, next_entry_name)
            ):
                if next_row.example:
                    header_examples.append(next_row.example)
                    header_example_x0 = next_row.example_x0 or header_example_x0
                next_index += 1
                continue
            if header_examples and is_signature_example_start(header_examples[-1]) and not is_complete_signature_example(header_examples[-1]):
                continuation = next_row.example or next_row.content
                if not next_row.label and continuation:
                    header_examples.append(continuation)
                    header_example_x0 = next_row.example_x0 or next_row.content_x0 or header_example_x0
                    next_index += 1
                    continue
            if not next_row.label and not next_row.content and next_row.example:
                header_examples.append(next_row.example)
                header_example_x0 = next_row.example_x0 or header_example_x0
                next_index += 1
                continue
            if (
                not next_row.label
                and next_row.content
                and not next_row.example
                and (
                    (next_row.content_x0 is not None and next_row.content_x0 >= 220)
                    or (header_examples and should_join_example(header_examples[-1], next_row.content))
                    or is_example_start(next_row.content)
                    or is_example_continuation(next_row.content)
                )
            ):
                header_examples.append(next_row.content)
                header_example_x0 = next_row.content_x0 or header_example_x0
                next_index += 1
                continue
            break

        merged_examples: list[str] = []
        for example in header_examples:
            text = normalize_signature_example(normalize_example(example))
            if not text:
                continue
            if merged_examples and (
                should_join_example(merged_examples[-1], text)
                or (is_signature_example_start(merged_examples[-1]) and not is_complete_signature_example(merged_examples[-1]))
            ):
                separator = "" if merged_examples[-1].endswith(("(", "[", "..")) else " "
                merged_examples[-1] = normalize_signature_example(normalize_example(f"{merged_examples[-1]}{separator}{text}"))
            elif text not in merged_examples:
                merged_examples.append(text)

        normalized.append(
            TableRow(
                label=row.label,
                content=row.content,
                example=merged_examples[0] if merged_examples else "",
                y=row.y,
                content_x0=row.content_x0,
                example_x0=header_example_x0,
            )
        )
        for example in merged_examples[1:]:
            normalized.append(TableRow(label="", content="", example=example, y=row.y, example_x0=header_example_x0))
        index = next_index
    return normalized


def normalize_example_span_rows(rows: list[TableRow]) -> list[TableRow]:
    normalized: list[TableRow] = []
    current_field: str | None = None
    example_span_active = False
    example_x0: float | None = None
    for source_row in rows:
        row = split_embedded_entry_example(source_row)
        if is_entry_start_row(row) or is_block_terminator_row(row):
            current_field = None
            example_span_active = False
            example_x0 = row.example_x0
            normalized.append(row)
            continue

        label = clean_text(row.label)
        if label in FIELD_SET:
            current_field = label
            if label in {"Zweck", "Bemerkungen"}:
                example_span_active = False
                example_x0 = None
            elif label in {"Parameter", "Rueckgabewerte", "Voraussetzung"}:
                example_span_active = True

        if example_span_active and row.example_x0 is not None:
            example_x0 = row.example_x0

        if (
            example_span_active
            and not row.label
            and row.content
            and not row.example
            and row.content_x0 is not None
            and (
                (example_x0 is not None and abs(row.content_x0 - example_x0) <= 40)
                or is_example_start(row.content)
                or is_example_continuation(row.content)
            )
        ):
            row = TableRow(
                label="",
                content="",
                example=normalize_example(row.content),
                y=row.y,
                content_x0=None,
                example_x0=row.content_x0,
            )
            example_x0 = row.example_x0

        normalized.append(row)
    return normalized


def row_with_spanning_content(row: TableRow) -> TableRow:
    merged = clean_text(" ".join(part for part in (row.content, row.example) if part))
    content_x0 = row.content_x0 if row.content else row.example_x0
    return TableRow(
        label=row.label,
        content=merged,
        example="",
        y=row.y,
        content_x0=content_x0,
        example_x0=None,
    )


def normalize_spanning_field_rows(rows: list[TableRow]) -> list[TableRow]:
    normalized: list[TableRow] = []
    current_field: str | None = None
    for row in rows:
        if is_entry_start_row(row) or is_block_terminator_row(row):
            current_field = None
            normalized.append(row)
            continue
        label = clean_text(row.label)
        if label in FIELD_SET:
            current_field = label
        if (label == "Bemerkungen" or (not label and current_field == "Bemerkungen")) and row.example:
            row = row_with_spanning_content(row)
        normalized.append(row)
    return normalized


def merge_row_text(row: TableRow) -> TableRow:
    merged = clean_text(" ".join(part for part in (row.content, row.example) if part))
    if not merged:
        return row
    return TableRow(
        label=row.label,
        content=merged,
        example="",
        y=row.y,
        content_x0=row.content_x0 if row.content else row.example_x0,
        example_x0=None,
    )


def normalize_layout_block_schema(block: list[TableRow]) -> list[TableRow]:
    if len(block) <= 1:
        return block
    callable_block = any(clean_text(row.label) in {"Parameter", "Rueckgabewerte"} for row in block[1:])
    if not callable_block:
        return block

    normalized: list[TableRow] = [block[0]]
    current_field: str | None = None
    in_header = True

    for row in block[1:]:
        label = clean_text(row.label)
        if label in FIELD_SET:
            current_field = label
            in_header = False
            if label in {"Zweck", "Bemerkungen"} and row.example:
                row = merge_row_text(row)
            normalized.append(row)
            continue

        if in_header:
            if not row.label and row.content and not row.example:
                row = TableRow(
                    label="",
                    content="",
                    example=normalize_example(row.content),
                    y=row.y,
                    content_x0=None,
                    example_x0=row.content_x0,
                )
            normalized.append(row)
            continue

        if current_field in {"Parameter", "Rueckgabewerte", "Voraussetzung"}:
            if not row.label and row.content and row.example:
                normalized.append(row)
                continue
            if not row.label and row.example:
                normalized.append(row)
                continue
            if not row.label and row.content and not row.example:
                normalized.append(row)
                continue
            normalized.append(row)
            continue

        if current_field in {"Zweck", "Bemerkungen"}:
            if row.example:
                row = merge_row_text(row)
            normalized.append(row)
            continue

        normalized.append(row)
    return normalized


def is_entry_start(line: str) -> bool:
    return bool(ENTRY_NAME_RE.fullmatch(clean_text(line)))


def is_entry_start_row(row: TableRow) -> bool:
    return is_entry_start(row.label) or is_entry_start(row.content)


def entry_name_from_row(row: TableRow) -> str:
    if is_entry_start(row.label):
        return normalize_entry_name(clean_text(row.label))
    if is_entry_start(row.content):
        return normalize_entry_name(clean_text(row.content))
    return ""


def is_block_terminator_row(row: TableRow) -> bool:
    return is_block_terminator(row.text())


def add_versions_from_content(entry: Entry, content: str) -> None:
    if not content:
        return
    for part in merge_prefix_parts(split_parts(content)):
        if looks_like_version_piece(part):
            entry.add_field("Voraussetzung", part)
        else:
            entry.add_field("Voraussetzung", part)


def add_spanning_field(entry: Entry, field_name: str, content: str = "", example: str = "") -> None:
    content = clean_text(content)
    example = clean_text(example)
    if field_name == "Zweck":
        if content:
            if content.startswith("-"):
                entry.add_field("Bemerkungen", content)
            else:
                entry.add_field("Zweck", content)
        if example:
            if example.startswith("-"):
                entry.add_field("Bemerkungen", example)
            else:
                entry.add_field("Zweck", example)
        return
    merged = clean_text(" ".join(part for part in (content, example) if part))
    if not merged:
        return
    if merged.startswith("-"):
        entry.add_field("Bemerkungen", merged)
        return
    entry.add_field(field_name, merged)


def parse_variable_rows(rows: list[TableRow]) -> Entry:
    name = entry_name_from_row(rows[0])
    entry = Entry(name=name, callable=False)
    current_field: str | None = None
    saw_voraussetzung = False
    saw_zweck = False
    header_example = normalize_example(rows[0].example)
    if header_example and header_example != name:
        entry.add_example(header_example)

    for row in rows[1:]:
        if is_noise(row.text()):
            continue
        label = clean_text(row.label)
        content = clean_text(row.content)
        example = normalize_example(row.example)

        if label == name or content == name:
            if example:
                entry.add_example(example)
            continue

        if label == "Voraussetzung":
            saw_voraussetzung = True
            current_field = "Voraussetzung"
            if content:
                for part in merge_prefix_parts(split_parts(content)):
                    if looks_like_version_piece(part):
                        entry.add_field("Voraussetzung", part)
            if example:
                entry.add_example(example)
            continue

        if label == "Zweck":
            saw_zweck = True
            current_field = "Zweck"
            add_spanning_field(entry, "Zweck", content, example)
            continue

        if not saw_voraussetzung:
            if content and looks_like_version_piece(content):
                entry.add_field("Voraussetzung", content)
            elif content:
                entry.add_example(content)
            if example:
                entry.add_example(example)
            continue

        if current_field == "Voraussetzung" and not saw_zweck:
            if content and looks_like_version_piece(content):
                entry.add_field("Voraussetzung", content)
            elif content:
                current_field = "Zweck"
                saw_zweck = True
                add_spanning_field(entry, "Zweck", content, example)
                continue
            if example:
                entry.add_example(example)
            continue

        if current_field == "Zweck" and (content or example):
            add_spanning_field(entry, "Zweck", content, example)
            continue
        if example:
            entry.add_example(example)

    return entry


def parse_function_rows(rows: list[TableRow]) -> Entry:
    name = re.sub(r"\s*\(\s*\)\s*$", "", entry_name_from_row(rows[0]))
    entry = Entry(name=name, callable=True)
    current_field: str | None = None
    header_example = normalize_example(rows[0].example)
    if header_example:
        entry.signature_example = header_example
        entry.add_example(header_example)

    for row in rows[1:]:
        if is_noise(row.text()):
            continue
        label = clean_text(row.label)
        content = clean_text(row.content)
        example = normalize_example(row.example)

        if label in {f"{name}()", name} or content in {f"{name}()", name}:
            signature = example or (content if content not in {f"{name}()", name} else "")
            if signature and not entry.signature_example:
                entry.signature_example = signature
            if signature:
                entry.add_example(signature)
            continue

        if label in FIELD_SET:
            current_field = label
            if label in {"Parameter", "Rueckgabewerte"}:
                if content and looks_like_count_fragment(content):
                    entry.add_field(label, content)
                elif content and not is_count_word(content):
                    entry.add_field("Bemerkungen", content)
                if example:
                    entry.add_example(example)
                continue
            if label == "Voraussetzung":
                if content:
                    for part in merge_prefix_parts(split_parts(content)):
                        if looks_like_version_piece(part):
                            entry.add_field("Voraussetzung", part)
                        else:
                            entry.add_example(part)
                if example:
                    entry.add_example(example)
                continue
            if label in {"Zweck", "Bemerkungen"}:
                add_spanning_field(entry, label, content, example)
                continue

        if current_field in {"Parameter", "Rueckgabewerte"}:
            if content and looks_like_count_fragment(content):
                entry.append_field_fragment(current_field, content)
            elif content and looks_like_version_piece(content):
                entry.add_field("Voraussetzung", content)
            elif content:
                entry.add_field("Bemerkungen", content)
            if example:
                entry.add_example(example)
            continue

        if current_field == "Voraussetzung":
            if content and looks_like_version_piece(content):
                entry.add_field("Voraussetzung", content)
            elif content:
                current_field = "Zweck"
                add_spanning_field(entry, "Zweck", content, example)
                continue
            if example:
                entry.add_example(example)
            continue

        if current_field in {"Zweck", "Bemerkungen"} and (content or example):
            merged = clean_text(" ".join(part for part in (content, example) if part))
            add_spanning_field(entry, current_field, content, example)
            if current_field == "Zweck" and merged.startswith("-"):
                current_field = "Bemerkungen"
            continue

        if content and (is_example_start(content) or is_example_continuation(content) or entry.examples):
            entry.add_example(content)
        if example:
            entry.add_example(example)

    return entry


def build_entries_layout_schema() -> list[Entry]:
    rows = normalize_layout_rows(layout_table_rows())
    blocks: list[list[TableRow]] = []
    current: list[TableRow] = []
    for row in rows:
        if current and is_block_terminator_row(row):
            if any(part.text() for part in current[1:]):
                blocks.append(current)
            current = []
            continue
        if is_entry_start_row(row):
            if current and entry_name_from_row(current[0]) == entry_name_from_row(row):
                current.append(row)
                continue
            if current:
                blocks.append(current)
            current = [row]
            continue
        if current:
            current.append(row)
    if current and any(part.text() for part in current[1:]):
        blocks.append(current)

    entries: list[Entry] = []
    for block in blocks:
        block = normalize_layout_block_schema(block)
        callable_block = any(row.label in {"Parameter", "Rueckgabewerte"} for row in block[1:])
        entries.append(normalize_entry_field_invariants(parse_function_rows(block) if callable_block else parse_variable_rows(block)))
    filtered: list[Entry] = []
    for entry in entries:
        entry.name = canonical_entry_name(entry)
        if is_spurious_layout_entry(entry):
            continue
        filtered.append(entry)

    deduped_by_name: dict[str, Entry] = {}
    for entry in filtered:
        matching_name = next(
            (
                name
                for name, previous_entry in deduped_by_name.items()
                if (not previous_entry.fields or not entry.fields) and are_similar_entry_names(name, entry.name)
            ),
            None,
        )
        if matching_name is not None:
            previous = deduped_by_name[matching_name]
            if entry_quality(entry) < entry_quality(previous):
                entry.name = matching_name
                deduped_by_name[matching_name] = entry
            continue
        previous = deduped_by_name.get(entry.name)
        if previous is None or entry_quality(entry) < entry_quality(previous):
            deduped_by_name[entry.name] = entry
    return list(deduped_by_name.values())


def build_entries() -> list[Entry]:
    return build_entries_layout_schema()


def entry_count_mismatch(entry: Entry, field_name: str, actual_count: int) -> bool:
    count_candidates = count_candidates_for_entry(entry, field_name)
    if not count_candidates:
        return False
    return not (min(count_candidates) <= actual_count <= max(count_candidates))


def entry_quality(entry: Entry) -> tuple[int, int, int, int, int, int]:
    params = parse_params(entry) if entry.callable else []
    returns = parse_returns(entry) if entry.callable else []
    placeholder_params = sum(1 for param in params if str(param["name"]).startswith("param") or str(param["desc"]).strip() == "Parameter.")
    missing_version = 0 if version_text(entry) else 1
    missing_examples = 0 if normalize_examples(entry.examples, entry.name) else 1
    param_mismatch = 1 if entry.callable and entry_count_mismatch(entry, "Parameter", len(params)) else 0
    return_mismatch = 1 if entry.callable and entry_count_mismatch(entry, "Rueckgabewerte", len(returns)) else 0
    note_penalty = 0 if entry.fields.get("Bemerkungen") else 1
    return (param_mismatch + return_mismatch, placeholder_params, missing_version, missing_examples, note_penalty, -len(entry.examples))


def normalize_entry_field_invariants(entry: Entry) -> Entry:
    zweck_lines = entry.fields.get("Zweck", [])
    if not zweck_lines:
        return entry
    kept_zweck: list[str] = []
    moved_bemerkungen: list[str] = []
    for line in zweck_lines:
        if clean_text(line).startswith("-"):
            moved_bemerkungen.append(clean_text(line))
        else:
            kept_zweck.append(line)
    if moved_bemerkungen:
        entry.fields["Zweck"] = kept_zweck
        if not entry.fields["Zweck"]:
            entry.fields.pop("Zweck", None)
        for line in moved_bemerkungen:
            entry.add_field("Bemerkungen", line)
    return entry


def canonical_entry_name(entry: Entry) -> str:
    current = re.sub(r"\s+", "", entry.name)
    current = re.sub(r"\(\)$", "", current)
    current = normalize_entry_name(current)
    if re.fullmatch(r"(EEP[A-Za-z0-9_]+|clearlog|print)", current):
        return current
    for example in normalize_examples(entry.examples, entry.name):
        match = re.search(r"\b(EEP[A-Za-z0-9_]+|clearlog|print)\s*\(", example)
        if match:
            candidate = normalize_entry_name(match.group(1))
            if not current:
                return candidate
            similarity = difflib.SequenceMatcher(a=current.lower(), b=candidate.lower()).ratio()
            if similarity >= 0.85:
                return candidate
            if re.fullmatch(r"EEPOn(?:Signal|Switch)_x", current) and re.fullmatch(r"EEPOn(?:Signal|Switch)_x", candidate):
                return current
    return current


def is_spurious_layout_entry(entry: Entry) -> bool:
    if entry.fields:
        return False
    examples = normalize_examples(entry.examples, entry.name)
    if not examples:
        return True
    for example in examples:
        if re.search(r"\b(EEP[A-Za-z0-9_]+|clearlog|print)\s*\(", example):
            return False
    return True


def normalize_entry_name(name: str) -> str:
    normalized = re.sub(r"\(\)$", "", re.sub(r"\s+", "", name))
    normalized = re.sub(r"EEPOn(Signal|Switch)_\d+$", r"EEPOn\1_x", normalized)
    return normalized


def are_similar_entry_names(left: str, right: str) -> bool:
    if left == right:
        return True
    if not left or not right:
        return False
    left_parts = split_entry_name_parts(left)
    right_parts = split_entry_name_parts(right)
    if len(left_parts) != len(right_parts) or len(left_parts) < 2:
        return False
    differing_pairs = [(left_part, right_part) for left_part, right_part in zip(left_parts, right_parts) if left_part != right_part]
    if len(differing_pairs) != 1:
        return False
    left_part, right_part = differing_pairs[0]
    similarity = difflib.SequenceMatcher(a=left_part.lower(), b=right_part.lower()).ratio()
    return similarity >= 0.85


def split_entry_name_parts(name: str) -> list[str]:
    return re.findall(r"[A-Z]+(?:[a-z0-9_]+|(?=[A-Z]|$))", name)


def normalize_version_format(value: str) -> str:
    text = clean_text(value).strip(";,")
    text = re.sub(r"Plugin(\d+)", r"Plugin \1", text)
    text = re.sub(r"-\s*Plugin\s*(\d+)", r"- Plugin \1", text)
    text = re.sub(r"EEP\s+([0-9]+(?:\.[0-9]+)?)\s+Plugin\s*-\s*Plugin\s*([0-9]+)", r"EEP \1 - Plugin \2", text)
    text = re.sub(r"EEP\s+([0-9]+(?:\.[0-9]+)?)\s+Plugin\s+([0-9]+)", r"EEP \1 - Plugin \2", text)
    text = re.sub(r"EEP\s+([0-9]+(?:\.[0-9]+)?)\s*-\s*Plugin\s*([0-9]+)", r"EEP \1 - Plugin \2", text)
    return text


def finalize_versions(parts: list[str]) -> list[str]:
    versions: list[str] = []
    pending: str | None = None
    for part in merge_prefix_parts(parts):
        text = clean_text(part).strip(".")
        if not text:
            continue
        text = re.sub(r"Plugin(\d+)", r"Plugin \1", text)
        if looks_like_complete_version(text):
            versions.append(normalize_version_format(text))
            pending = None
            continue
        if re.fullmatch(r"EEP\s+\d+(?:\.\d+)?\s+Plugin", text):
            pending = text
            continue
        if re.fullmatch(r"-\s*Plugin\s*\d+;?", text):
            plugin_number = re.search(r"(\d+)", text)
            plugin = plugin_number.group(1) if plugin_number else ""
            if pending:
                versions.append(normalize_version_format(f"{pending} - Plugin {plugin}"))
                pending = None
            elif versions:
                previous = versions.pop()
                if " - Plugin " not in previous:
                    versions.append(normalize_version_format(f"{previous} - Plugin {plugin}"))
                else:
                    versions.append(previous)
            continue
        if re.fullmatch(r"\d+;?", text) and pending:
            versions.append(normalize_version_format(f"{pending} {text.strip(';')}"))
            pending = None
            continue
        if pending:
            versions.append(normalize_version_format(pending))
            pending = None
    if pending:
        versions.append(normalize_version_format(pending))
    deduped: list[str] = []
    for version in versions:
        if version and version not in deduped:
            deduped.append(version)
    return deduped


def join_example_parts(parts: list[str]) -> str:
    if not parts:
        return ""
    text = join_parts(parts)
    if text == "--":
        return ""
    return normalize_signature_example(text)


def is_signature_example_start(text: str) -> bool:
    return bool(re.match(r"^(EEP[A-Za-z0-9_]+|print|clearlog)\s*\(", clean_text(text)))


def normalize_signature_example(text: str) -> str:
    normalized = clean_text(text)
    normalized = re.sub(r"\b(EEP[A-Za-z0-9_]+|print|clearlog)\s+\(", r"\1(", normalized)
    normalized = re.sub(r"\b(EEP[A-Za-z0-9_]+|print|clearlog)\(\s+", r"\1(", normalized)
    normalized = re.sub(r"\s+\)", ")", normalized)
    return normalized


def is_complete_signature_example(text: str) -> bool:
    normalized = normalize_signature_example(text)
    if not is_signature_example_start(normalized):
        return False
    return bracket_balance(normalized) <= 0 and normalized.rstrip().endswith(")")


def is_example_start(text: str) -> bool:
    lower = text.lower()
    if lower == "end":
        return True
    if lower.startswith(("if ", "elseif ", "else", "function ", "return ", "--")):
        return True
    if re.match(r"^[A-Za-z_][A-Za-z0-9_]*(?:\s*,\s*[A-Za-z_][A-Za-z0-9_]*)*\s*=", text):
        return True
    if is_signature_example_start(text):
        return True
    return False


def is_example_continuation(text: str) -> bool:
    if text in {"end", "then"}:
        return True
    return text.startswith(('"', "'", "[", "]", ")", ",", "="))


def previous_example_is_open(value: str) -> bool:
    text = normalize_example(value)
    if not text:
        return False
    if bracket_balance(text) > 0:
        return True
    if text.endswith(("=", ",", "(", "[", "..")):
        return True
    return False


def purpose_text(entry: Entry) -> str:
    return clean_text(" ".join(entry.fields.get("Zweck", [])))


def version_text(entry: Entry) -> str:
    versions = finalize_versions(entry.fields.get("Voraussetzung", []))
    return "; ".join(versions)


def collect_bullets(lines: list[str]) -> list[str]:
    bullets: list[str] = []
    current = ""
    for line in lines:
        text = clean_text(line)
        if not text:
            continue
        if text.startswith(("-", "·")):
            if current:
                bullets.append(current)
            current = text[1:].strip()
            continue
        if re.match(r"^[oO]\s+", text):
            if current:
                bullets.append(current)
            current = text.strip()
            continue
        if current:
            current = f"{current} {text}".strip()
    if current:
        bullets.append(current)
    return bullets


def strip_sub_bullet_prefix(text: str) -> str:
    return re.sub(r"^[oO]\s+", "", clean_text(text))


def is_sub_bullet(text: str) -> bool:
    return bool(re.match(r"^[oO]\s+", clean_text(text)))


def strip_leading_version_prefix(text: str) -> str:
    normalized = clean_text(text)
    return re.sub(
        r"^Ab\s+EEP\b.*?\b(?=(?:Der|In|Ueber|kann|Eine|Die)\b)",
        "",
        normalized,
        flags=re.IGNORECASE,
    ).strip()


def count_from_token(token: str) -> int | None:
    text = clean_text(token).lower().strip(";,")
    if re.fullmatch(r"\d+", text):
        return int(text)
    return COUNT_WORD_MAP.get(text)


def extract_param_range(bullet: str) -> tuple[int, int] | None:
    normalized = clean_text(bullet)
    match = PARAM_RANGE_RE.match(normalized)
    if match:
        return int(match.group(1)), int(match.group(2))
    first_n_match = re.match(r"^Die\s+ersten\s+([A-Za-z0-9]+)\s+Parameter\b", normalized, re.IGNORECASE)
    if first_n_match:
        count = count_from_token(first_n_match.group(1))
        if count is not None:
            return 1, count
    return None


def is_param_bullet(text: str) -> bool:
    prefix = strip_leading_version_prefix(strip_sub_bullet_prefix(text))[:96]
    return bool(
        re.search(
            r"^(?:Der\s+(?:optionale[nr]?\s+)?Parameter\b|"
            r"Der\s+optionale[nr]?\s+\d+\.\s*Parameter\b|"
            r"Ueber\s+den\s+optionale[nr]?\s+\d+\.\s*Parameter\b|"
            r"In\s+den\s+\d+\.\s*Parameter\b|"
            r"Der\s+\(\d+\.\)\s+Parameter\b|"
            r"Der\s+\d+\.\s*(?:\([^)]+\)\s+)?Parameter\b|"
            r"kann\s+ein\s+(?:optionale[nr]?\s+)?\d+\.\s*(?:\([^)]+\)\s+)?Parameter\b|"
            r"optional(?:e[nr]?|er|en)?\s+\d+\.\s*Parameter\b|"
            r"Eine\s+\d+\s+als\s+\d+\.\s*(?:\([^)]+\)\s+)?Parameter\b)",
            prefix,
            re.IGNORECASE,
        )
    )


def infer_type(desc: str) -> str:
    lower = desc.lower()
    if "route" in lower:
        return "string"
    if "zeichenkette" in lower or re.search(r"\bstring\b", lower):
        return "string"
    if "true" in lower or "false" in lower or "boolean" in lower:
        return "boolean"
    if "string" in lower or "zeichenkette" in lower or "text" in lower or "name" in lower:
        return "string"
    if "stellung" in lower or "kameraposition" in lower or "anzahl" in lower:
        return "number"
    if "id" in lower or "zahl" in lower or "nummer" in lower or "sekunde" in lower or "stunde" in lower:
        return "number"
    if "km/h" in lower or "meter" in lower or "grad" in lower:
        return "number"
    return "any"


def infer_param_name(desc: str, index: int) -> str:
    lower = desc.lower()
    if "status der pause" in lower or "status der" in lower:
        return "status"
    if "stundenangabe" in lower:
        return "stunde"
    if "farbtoneinstellung" in lower:
        return "hue"
    if "saettigungseinstellung" in lower:
        return "saturation"
    if "helligkeitseinstellung" in lower:
        return "brightness"
    if "kontrasteinstellung" in lower:
        return "contrast"
    if "minutenangabe" in lower:
        return "minute"
    if "sekundenangabe" in lower:
        return "seconds"
    if "fahrzeugverbands" in lower or "fahrzeugverband" in lower or "zugname" in lower:
        return "trainName"
    if "name des fahrzeugs" in lower or "fahrzeugname" in lower:
        return "rollingstockName"
    if "rollmaterials" in lower or "rollmaterial" in lower:
        return "rollingstockName"
    if "virtuellen depot" in lower or "virtuellen depots" in lower:
        return "depotId"
    if "signal-id" in lower or "signal id" in lower:
        return "signalId"
    if "signals" in lower and "id" in lower:
        return "signalId"
    if ("weiche" in lower or "weichen-id" in lower) and "id" in lower:
        return "switchId"
    if "id des gleises" in lower or "zu registrierenden gleises" in lower:
        return "gleisID"
    if "id der strasse" in lower or "zu registrierenden strasse" in lower:
        return "strassenID"
    if "id des strassenbahngleises" in lower or "zu registrierenden strassenbahngleises" in lower:
        return "strassenbahngleisID"
    if 'id des weges der kategorie "sonstige"' in lower or "zu registrierenden weges der kategorie" in lower:
        return "wegID"
    if "id der zu registrierenden steuerstrecke" in lower or "id der steuerstrecke" in lower:
        return "steuerstreckenID"
    if "speicherplatz" in lower or '"slot"' in lower:
        return "speichernummer"
    if "positionsnummer" in lower or "position in der depotliste" in lower:
        return "index"
    if "position in der auswahlbox" in lower:
        return "listenplatz"
    if "zielnummer der fahrstrasse" in lower:
        return "fahrstrassenZielnummer"
    if "neuer name" in lower:
        return "name2"
    if "wetterzone" in lower and ("nummer" in lower or "zonennummer" in lower):
        return "zoneId"
    if "name der achse" in lower:
        return "axisName"
    if "name des beweglichen teils" in lower:
        return "axisName"
    if "achsnummer der zu bewegenden achse" in lower:
        return "achsnummer"
    if "position, zu der sich die achse bewegen soll" in lower or "schrittzahl" in lower:
        return "position"
    if "kamera" in lower and "typ" in lower:
        return "cameraType"
    if "name der kamera" in lower:
        return "cameraName"
    if "textgroesse" in lower:
        return "textSize"
    if "textausrichtung" in lower:
        return "alignment"
    if "laufgeschwindigkeit" in lower:
        return "scrollSpeed"
    if "position in x-richtung" in lower or "x-position" in lower:
        return "posX"
    if "position in y-richtung" in lower or "y-position" in lower:
        return "posY"
    if "position in z-richtung" in lower or "z-position" in lower:
        return "posZ"
    if "drehung um die x-achse" in lower:
        return "rotX"
    if "drehung um die y-achse" in lower:
        return "rotY"
    if "drehung um die z-achse" in lower:
        return "rotZ"
    if "zonenmittelpunktes" in lower and "x-richtung" in lower:
        return "posX"
    if "zonenmittelpunktes" in lower and "y-richtung" in lower:
        return "posY"
    if "zonenmittelpunktes" in lower and "z-richtung" in lower:
        return "posZ"
    if "kameraposition x" in lower:
        return "posX"
    if "kameraposition y" in lower:
        return "posY"
    if "kameraposition z" in lower:
        return "posZ"
    if "kameraausrichtung um die x-achse" in lower:
        return "rotX"
    if "kameraausrichtung um die y-achse" in lower:
        return "rotY"
    if "kameraausrichtung um die z-achse" in lower:
        return "rotZ"
    if "radius der wetterzone" in lower:
        return "radius"
    if "route" in lower:
        return "route"
    if "text" in lower:
        return "text"
    if "eeponsignal_" in lower or "eeponswitch_" in lower or "aufgerufen wird" in lower:
        return "rueckruf"
    if "flaeche" in lower and "nummer" in lower:
        return "surfaceNumber"
    if "wolkenanteil" in lower or "regenstaerke" in lower or "hagel" in lower or "graupel" in lower:
        return "intensity"
    if "dateiname einschliesslich" in lower or "unterordner" in lower:
        return "projectPath"
    if "speicherpfad der anlage" in lower:
        return "projectPath"
    if "pfad" in lower and "wav-datei" in lower:
        return "soundFile"
    if "lua name des soundmodells" in lower:
        return "luaName"
    if '"stellpult-name"' in lower:
        return "ctrlDeskName"
    if "geschwindigkeit" in lower:
        return "speed"
    if "wolken-modus" in lower or "modus" in lower:
        return "mode"
    if "lichtquelle" in lower or "quelle" in lower:
        return "quelle"
    if "achsgruppe" in lower:
        return "achsengruppe"
    if "stellung" in lower:
        return "stellung"
    if "von vorne oder hinten" in lower:
        return "fromFront"
    if "wahr" in lower or "schaltet" in lower or "true" in lower or "false" in lower:
        return "state"
    if "anzahl an rollmaterialien" in lower or "anzahl" in lower:
        return "count"
    if "halteabstand" in lower:
        return "stopDistance"
    if "jahreszeit" in lower:
        return "season"
    if "windstaerke" in lower:
        return "windstaerke"
    if "schneefallstaerke" in lower:
        return "schneefallstaerke"
    if "nebeldichte" in lower:
        return "nebeldichte"
    if "kranhaken" in lower and "nummer" in lower:
        return "kranhakennummer"
    if "lua-name" in lower or "name der immobilie" in lower or "name des ladeguts" in lower:
        return "luaName"
    if "sekunden" in lower:
        return "seconds"
    return f"param{index}"


def infer_return_name(desc: str, index: int) -> str:
    lower = desc.lower()
    if index == 1 and "true" in lower and "false" in lower:
        return "ok"
    if "ungleich null" in lower and "funktion" in lower:
        return "weiterlauf"
    if "ausgegebene string" in lower or "ausgegebene zeichenkette" in lower:
        return "text"
    if "anzahl" in lower:
        return "count"
    if "funktion" in lower:
        return "funktion"
    if "länge" in lower or "laenge" in lower:
        return "laenge"
    if "id des gleisstücks" in lower or ("gleisstücks" in lower and "id" in lower):
        return "gleisId"
    if "abstand" in lower and "gleisstücks" in lower:
        return "position"
    if "fahrtrichtung" in lower:
        return "richtung"
    if "gleissystems" in lower:
        return "system"
    if "x-position" in lower:
        return "posX"
    if "y-position" in lower:
        return "posY"
    if "z-position" in lower:
        return "posZ"
    if "drehung um die x-achse" in lower:
        return "rotX"
    if "drehung um die y-achse" in lower:
        return "rotY"
    if "drehung um die z-achse" in lower:
        return "rotZ"
    if "x-achse" in lower and "kameraposition" in lower:
        return "posX"
    if "y-achse" in lower and "kameraposition" in lower:
        return "posY"
    if "z-achse" in lower and "kameraposition" in lower:
        return "posZ"
    if "horizontale" in lower and "kameraausrichtung" in lower:
        return "rotH"
    if "vertikale" in lower and "kameraausrichtung" in lower:
        return "rotV"
    if "brennt" in lower:
        return "brennt"
    if "text" in lower:
        return "text"
    if "route" in lower:
        return "route"
    if "stellung" in lower:
        return "stellung"
    if "geschwindigkeit" in lower:
        return "speed"
    if "bildrate" in lower:
        return "fps"
    if "kameraposition" in lower:
        return "cameraPosition"
    if "name" in lower:
        return "name"
    if "status" in lower:
        return "status"
    if "kategorie" in lower or "typ" in lower:
        return "typ"
    return f"value{index}"


def short_desc(text: str) -> str:
    text = strip_leading_version_prefix(strip_sub_bullet_prefix(text))
    text = re.sub(r"^Der\s+\d+\.\s+\([^)]+\)\s*", "", text)
    text = re.sub(r"^Der\s+\((\d+\.)\)\s*", "", text)
    text = re.sub(r"^Der\s+\d+\.\s*", "", text)
    text = re.sub(r"^Der\s+\d+\.\s*(?=Parameter\b)", "", text)
    text = re.sub(r"^In\s+den\s+\d+\.\s*Parameter\s+", "", text)
    text = re.sub(r"^Der\s+", "", text)
    text = re.sub(r"^Die\s+", "", text)
    return text[:1].lower() + text[1:] if text else ""


def sanitize_hint_name(text: str) -> str:
    raw = clean_text(text)
    quoted = (raw.startswith('"') and raw.endswith('"')) or (raw.startswith("'") and raw.endswith("'"))
    hint = raw
    hint = hint.strip("[]()")
    hint = hint.replace("#", "")
    hint = hint.replace('"', "")
    hint = hint.replace("'", "")
    hint = re.sub(r"\s+", "", hint)
    hint = hint.replace("|", "")
    hint = hint.replace("-", "")
    replacements = {
        "Name": "name",
        "Name2": "name2",
        "Fahrzeugname": "rollingstockName",
        "Zugname": "trainName",
        "Quelle": "quelle",
        "Position": "position",
        "Stellung": "stellung",
        "Anzahl": "count",
        "Achse": "axisName",
        "SignalID": "signalId",
        "Pos_X": "posX",
        "Pos_Y": "posY",
        "Pos_Z": "posZ",
        "Rot_H": "rotH",
        "Rot_V": "rotV",
        "IstGeschwindigkeit": "istGeschwindigkeit",
        "ReiseGeschwindigkeit": "reiseGeschwindigkeit",
    }
    if hint in replacements:
        return replacements[hint]
    if hint.lower() in {"true", "false", "truefalse", "falsetrue"}:
        return "state"
    if quoted:
        generic_quoted_hints = {
            "name",
            "name2",
            "fahrzeugname",
            "zugname",
            "achse",
            "quelle",
            "position",
            "stellung",
            "anzahl",
            "lua-name",
            "luaName",
            "text",
            "route",
        }
        lowered = hint.lower()
        if lowered not in generic_quoted_hints and hint not in replacements:
            return ""
    if not hint:
        return ""
    hint = re.sub(r"[^A-Za-z0-9_]", "", hint)
    if not hint or not re.match(r"[A-Za-z_]", hint):
        return ""
    return hint[:1].lower() + hint[1:]


def infer_type_from_hint(name: str) -> str:
    lower = name.lower()
    if lower == "truezahl":
        return "boolean|number"
    if lower in {"state", "fromfront", "vorwaerts", "brennt", "besetzt"}:
        return "boolean"
    if (
        lower.endswith("id")
        or lower in {
            "r",
            "g",
            "b",
            "position",
            "speed",
            "count",
            "seconds",
            "posx",
            "posy",
            "posz",
            "rotx",
            "roty",
            "rotz",
            "roth",
            "rotv",
            "radius",
            "season",
            "zoneid",
            "zonennummer",
            "depotid",
            "mode",
            "stellung",
            "quelle",
            "achsnummer",
            "fahrtrichtung",
            "rueckruf",
            "listenplatz",
            "kranhakennummer",
        }
    ):
        return "number"
    if lower == "text" or lower.endswith("name"):
        return "string"
    return "any"


def extract_param_index(bullet: str, fallback: int) -> int:
    bullet = strip_leading_version_prefix(strip_sub_bullet_prefix(bullet))
    patterns = (
        r"Ueber\s+den\s+optionale[nr]?\s+(\d+)\.\s*Parameter\b",
        r"Der\s+optionale[nr]?\s+(\d+)\.\s*Parameter\b",
        r"In\s+den\s+(\d+)\.\s*Parameter\b",
        r"\((\d+)\.\)\s+Parameter\b",
        r"(\d+)\.\s*\([^)]+\)\s+Parameter\b",
        r"(\d+)\.\s*Parameter\b",
        r"ein\s+optionale[nr]?\s+(\d+)\.\s*(?:\([^)]+\)\s+)?Parameter\b",
        r"ein\s+(\d+)\.\s*(?:\([^)]+\)\s+)?Parameter\b",
        r"als\s+(\d+)\.\s*(?:\([^)]+\)\s+)?Parameter\b",
    )
    for pattern in patterns:
        match = re.search(pattern, bullet, re.IGNORECASE)
        if match:
            return int(match.group(1))
    return fallback


def extract_return_index(bullet: str, fallback: int) -> int:
    patterns = (
        r"\((\d+)\.\)\s+Rueckgabewert\b",
        r"(\d+)\.\s*\([^)]+\)\s+Rueckgabewert\b",
        r"(\d+)\.\s*Rueckgabewert\b",
    )
    for pattern in patterns:
        match = re.search(pattern, bullet, re.IGNORECASE)
        if match:
            return int(match.group(1))
    return fallback


def infer_group_param_names(bullet: str, start: int, end: int) -> list[str]:
    lower = bullet.lower()
    size = end - start + 1
    if size == 3 and all(token in lower for token in ("rot", "gruen", "blau")):
        return ["red", "green", "blue"]
    if size == 3 and all(token in lower for token in ("x", "y", "z")):
        return ["posX", "posY", "posZ"]
    if size == 3 and "rot" in lower and "vertikal" in lower and "horizontal" in lower:
        return ["rotX", "rotH", "rotV"]
    return [f"param{index}" for index in range(start, end + 1)]


def extract_lhs_names(example: str, entry_name: str) -> list[str]:
    text = normalize_example(example)
    match = re.match(r"^(.+?)=\s*(.+)$", text)
    if not match:
        return []
    lhs = match.group(1).strip()
    rhs = match.group(2).strip()
    if entry_name not in rhs:
        return []
    names = [sanitize_hint_name(part) for part in lhs.split(",")]
    return [name for name in names if name]


def trim_trailing_prose_after_call(text: str, entry_name: str) -> str:
    marker = f"{entry_name}("
    start = text.find(marker)
    if start == -1:
        return text
    depth = 0
    in_string = False
    string_char = ""
    close_index = -1
    for index in range(start + len(entry_name), len(text)):
        char = text[index]
        if in_string:
            if char == string_char:
                in_string = False
            continue
        if char in {'"', "'"}:
            in_string = True
            string_char = char
            continue
        if char == "(":
            depth += 1
            continue
        if char == ")":
            depth -= 1
            if depth == 0:
                close_index = index
                break
    if close_index == -1:
        return text
    suffix = text[close_index + 1 :].strip()
    if not suffix:
        return text
    if suffix.startswith(("--", ",", ")", "]", "==", "~=", "<=", ">=", "<", ">", "+", "-", "*", "/", "%", "^", "..", ".", ":", "[")):
        return text
    if re.match(r"^(and|or|then|do)\b", suffix):
        return text
    if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", suffix):
        return text
    if re.match(r"^\d+\b", suffix):
        return text
    return text[: close_index + 1]


def normalize_examples(examples: list[str], entry_name: str) -> list[str]:
    normalized: list[str] = []
    buffer = ""

    def flush() -> None:
        nonlocal buffer
        if buffer:
            normalized.append(buffer.strip())
            buffer = ""

    for example in examples:
        text = normalize_example(example)
        if not text:
            continue
        if any(text.startswith(label) for label in FIELD_LABELS):
            continue
        text = re.sub(r"^\d+\s+(?=(print|if|elseif|EEP[A-Za-z0-9_]+)\b)", "", text)
        text = re.sub(r"^(--\s+)+", "-- ", text)
        text = trim_trailing_prose_after_call(text, entry_name)
        if text == "--":
            continue
        if not buffer:
            buffer = text
            continue
        if should_join_example(buffer, text):
            separator = "" if buffer.endswith(("(", "[", "..")) else " "
            buffer = f"{buffer}{separator}{text}".strip()
            continue
        flush()
        buffer = text
    flush()
    return normalized


def should_join_example(previous: str, current: str) -> bool:
    prev = previous.strip()
    curr = current.strip()
    if not prev or not curr:
        return False
    if prev.endswith(("(", "[", ",", "=", "..")):
        return True
    if curr.startswith((")", "]", ",", "[", '"', "'")):
        return True
    if prev.startswith("--") and not curr.startswith("--"):
        if not is_example_start(curr) and not re.match(r"^[A-Za-z_][A-Za-z0-9_]*\s*=", curr):
            return True
        return False
    if curr.startswith("--") and not prev.startswith("--"):
        return False
    if is_example_start(prev) and is_example_start(curr):
        return False
    if prev.count('"') % 2 == 1 or prev.count("'") % 2 == 1:
        return True
    if bracket_balance(prev) > 0:
        return True
    return False


def bracket_balance(value: str) -> int:
    return value.count("(") - value.count(")") + value.count("[") - value.count("]")


def extract_signature_hints(entry: Entry) -> list[str]:
    for example in normalize_examples(entry.examples, entry.name):
        args_match = None
        if example.startswith(f"{entry.name}("):
            args_match = re.match(rf"^{re.escape(entry.name)}\((.*)\)$", example)
        elif example.startswith(f"function {entry.name}("):
            args_match = re.match(rf"^function\s+{re.escape(entry.name)}\((.*)\)$", example)
        else:
            args_match = re.search(rf"{re.escape(entry.name)}\((.*)\)$", example)
        if not args_match:
            continue
        args = [sanitize_hint_name(part) for part in args_match.group(1).split(",")]
        if any(args):
            return args
    return []


def apply_param_hints_from_examples(params: list[dict[str, object]], entry: Entry) -> None:
    hints = extract_signature_hints(entry)
    if not hints:
        return
    for param, hint in zip(params, hints):
        current_name = str(param["name"])
        if not hint:
            continue
        current_generic = current_name.lower() in {"name", "luaname", "text", "state", "mode", "stellung"}
        hint_generic = hint.lower() in {"name", "luaname", "text", "state", "mode", "stellung"}
        if current_name.startswith("param"):
            param["name"] = hint
            continue
        if current_generic and (not hint_generic or current_name.lower() in {"state", "mode", "stellung"}):
            param["name"] = hint
            continue
        if current_name.endswith("Name") and not hint_generic and not hint.endswith("Name"):
            param["name"] = hint


def apply_param_type_hints_from_names(params: list[dict[str, object]]) -> None:
    for param in params:
        name = str(param["name"])
        hinted_type = infer_type_from_hint(name)
        if hinted_type == "any":
            continue
        if str(param["type"]) == "any" or name == "trueZahl":
            param["type"] = hinted_type


def apply_return_hints_from_examples(returns: list[dict[str, str]], entry: Entry) -> None:
    best_hints: list[str] = []
    for example in normalize_examples(entry.examples, entry.name):
        hints = extract_lhs_names(example, entry.name)
        if len(hints) > len(best_hints):
            best_hints = hints
    replaceable_names = {
        "cameraPosition",
        "speed",
        "count",
        "name",
        "text",
        "route",
        "stellung",
        "typ",
    }
    for ret, hint in zip(returns, best_hints):
        if ret["name"].startswith("value") or ret["name"] in replaceable_names:
            ret["name"] = hint


def uniquify_params(params: list[dict[str, object]]) -> list[dict[str, object]]:
    seen: dict[str, int] = {}
    for param in params:
        name = str(param["name"])
        count = seen.get(name, 0)
        if count:
            param["name"] = f"{name}{count + 1}"
        seen[name] = count + 1
    return params


ALIAS_DEFINITIONS: dict[str, list[str]] = {
    "EEPPauseStatus": [
        "---@alias EEPPauseStatus",
        "---| 0 # Betrieb weiter",
        "---| 1 # Betrieb gestoppt, Lua laeuft weiter",
        "---| 2 # Betrieb und Lua gestoppt",
    ],
    "EEPTrainLightSource": [
        "---@alias EEPTrainLightSource",
        "---| 0 # Fahrlicht und Innenraumbeleuchtung",
        "---| 1 # Linker Blinker",
        "---| 2 # Rechter Blinker",
        "---| 3 # Bremslicht-Automatik",
    ],
    "EEPCouplingState": [
        "---@alias EEPCouplingState",
        "---| 1 # Kupplung scharf",
        "---| 2 # Abstossen",
    ],
    "EEPRollingstockCouplingStatus": [
        "---@alias EEPRollingstockCouplingStatus",
        "---| 1 # Kupplung scharf",
        "---| 2 # Abstossen",
        "---| 3 # Gekuppelt",
    ],
    "EEPRollingstockTrackDirection": [
        "---@alias EEPRollingstockTrackDirection",
        "---| 1 # In Fahrtrichtung",
        "---| 0 # Entgegen der Fahrtrichtung",
    ],
    "EEPTrackSystem": [
        "---@alias EEPTrackSystem",
        "---| 1 # Bahngleise",
        "---| 2 # Strassen",
        "---| 3 # Tramgleise",
        "---| 4 # Sonstige Splines oder Wasserwege",
    ],
    "EEPRollingstockModelType": [
        "---@alias EEPRollingstockModelType",
        "---| 1 # Tenderlok",
        "---| 2 # Schlepptenderlok",
        "---| 3 # Tender",
        "---| 4 # Elektrolok",
        "---| 5 # Diesellok",
        "---| 6 # Triebwagen",
        "---| 7 # U- oder S-Bahn",
        "---| 8 # Strassenbahn",
        "---| 9 # Gueterwaggon",
        "---| 10 # Personenwaggon",
        "---| 11 # Luftfahrzeug",
        "---| 12 # Maschine",
        "---| 13 # Wasserfahrzeug",
        "---| 14 # LKW",
        "---| 15 # PKW",
    ],
    "EEPStructureModelType": [
        "---@alias EEPStructureModelType",
        "---| 16 # Gleisobjekte Bahngleise",
        "---| 17 # Gleisobjekte Strassenbahn",
        "---| 18 # Gleisobjekte Strassen",
        "---| 19 # Gleisobjekte Wasserwege oder Diverse",
        "---| 22 # Immobilien",
        "---| 23 # Landschaftselemente Fauna",
        "---| 24 # Landschaftselemente Flora",
        "---| 25 # Landschaftselemente Terra",
        "---| 38 # Landschaftselemente Bodenmodelle zur 3D-Texturierung",
    ],
    "EEPGoodsModelType": [
        "---@alias EEPGoodsModelType",
        "---| 20 # Gueter mit kubischer Form",
        "---| 21 # Gueter mit zylindrischer Form",
    ],
    "EEPRollingstockHookStatus": [
        "---@alias EEPRollingstockHookStatus",
        "---| 0 # Ausgeschaltet",
        "---| 1 # Eingeschaltet",
        "---| 3 # Ladegut am Haken",
    ],
    "EEPHookGlueMode": [
        "---@alias EEPHookGlueMode",
        "---| 0 # Gueter schaukeln",
        "---| 1 # Gueter sind fixiert",
    ],
    "EEPCameraType": [
        "---@alias EEPCameraType",
        "---| 0 # Statisch",
        "---| 1 # Dynamisch",
        "---| 2 # Mobile Kamera",
    ],
    "EEPPerspectiveCameraPosition": [
        "---@alias EEPPerspectiveCameraPosition",
        "---| 1 # Direkt auf die linke Seite des Fahrzeugverbandes",
        "---| 2 # Direkt auf die rechte Seite des Fahrzeugverbandes",
        "---| 3 # Seitlich von oben auf die linke Seite des Fahrzeugverbandes",
        "---| 4 # Seitlich von oben auf die rechte Seite des Fahrzeugverbandes",
        "---| 5 # Von der Front des Fahrzeugverbandes in Fahrtrichtung",
        "---| 6 # Von vorn auf die Front des Fahrzeugverbandes",
        "---| 7 # Automatische Kamera am naechsten zum Fahrzeugverband",
        "---| 8 # Aus dem Fuehrerstand",
        "---| 9 # Oberhalb des Fahrzeugverbandes oder User-Kamera",
        "---| 10 # Perspektive der alten Kabine",
    ],
    "EEPTrainyardDepartureOrientation": [
        "---@alias EEPTrainyardDepartureOrientation",
        "---| 0 # Wie im Depot vorgegeben",
        "---| 1 # Vorwaerts",
        "---| 2 # Rueckwaerts",
        "---| 3 # Entgegengesetzt zur Depotvorgabe",
    ],
    "EEPTrainyardItemStatus": [
        "---@alias EEPTrainyardItemStatus",
        "---| 0 # In Fahrt",
        "---| 1 # Im Depot wartend",
    ],
    "EEPInfoTextAlignment": [
        "---@alias EEPInfoTextAlignment",
        "---| 0 # Blocksatz",
        "---| 1 # Zentriert",
        "---| 2 # Linksbuendig",
        "---| 3 # Rechtsbuendig",
    ],
    "EEPCloudMode": [
        "---@alias EEPCloudMode",
        "---| 0 # Keine Wolken",
        "---| 1 # Wolken",
        "---| 2 # Dunkle Wolken",
    ],
    "EEPSeason": [
        "---@alias EEPSeason",
        "---| 1 # Fruehling",
        "---| 2 # Sommer",
        "---| 3 # Herbst",
        "---| 4 # Winter",
    ],
}


ENTRY_TYPE_OVERRIDES: dict[str, dict[str, dict[int, dict[str, object]]]] = {
    "EEPPause": {
        "params": {
            1: {"type": "EEPPauseStatus", "desc": "parameter bestimmt den Status der Pause."},
        }
    },
    "EEPSetTrainLight": {
        "params": {
            3: {"type": "EEPTrainLightSource", "desc": "optionaler Parameter definiert die Lichtquelle."},
        }
    },
    "EEPGetTrainLight": {
        "params": {
            2: {"type": "EEPTrainLightSource", "desc": "optionaler Parameter definiert die Lichtquelle."},
        }
    },
    "EEPGetTrainCouplingFront": {
        "returns": {
            2: {"type": "EEPCouplingState", "desc": "rueckgabewert ist die Stellung der vorderen Kupplung."},
        }
    },
    "EEPGetTrainCouplingRear": {
        "returns": {
            2: {"type": "EEPCouplingState", "desc": "rueckgabewert ist die Stellung der hinteren Kupplung."},
        }
    },
    "EEPRollingstockSetCouplingFront": {
        "params": {
            2: {"type": "EEPCouplingState", "desc": "parameter ist der gewuenschte Kupplungszustand."},
        }
    },
    "EEPRollingstockSetCouplingRear": {
        "params": {
            2: {"type": "EEPCouplingState", "desc": "parameter ist der gewuenschte Kupplungszustand."},
        }
    },
    "EEPRollingstockGetCouplingFront": {
        "returns": {
            2: {"type": "EEPRollingstockCouplingStatus", "desc": "rueckgabewert ist die Stellung der Kupplung."},
        }
    },
    "EEPRollingstockGetCouplingRear": {
        "returns": {
            2: {"type": "EEPRollingstockCouplingStatus", "desc": "rueckgabewert ist die Stellung der Kupplung."},
        }
    },
    "EEPRollingstockGetTrack": {
        "returns": {
            4: {
                "type": "EEPRollingstockTrackDirection",
                "desc": "rueckgabewert ist die Ausrichtung relativ zur Fahrtrichtung des Gleisstuecks.",
            },
            5: {"type": "EEPTrackSystem", "desc": "rueckgabewert ist die Nummer des Gleissystems."},
        }
    },
    "EEPRollingstockGetModelType": {
        "returns": {
            2: {"type": "EEPRollingstockModelType", "desc": "rueckgabewert ist die Modellkategorie."},
        }
    },
    "EEPStructureGetModelType": {
        "returns": {
            2: {"type": "EEPStructureModelType", "desc": "rueckgabewert ist die Modellkategorie."},
        }
    },
    "EEPGoodsGetModelType": {
        "returns": {
            2: {"type": "EEPGoodsModelType", "desc": "rueckgabewert ist die Modellkategorie."},
        }
    },
    "EEPRollingstockGetHook": {
        "returns": {
            2: {"type": "EEPRollingstockHookStatus", "desc": "rueckgabewert gibt den Status des Hakens an."},
        }
    },
    "EEPRollingstockGetHookGlue": {
        "returns": {
            1: {"type": "EEPHookGlueMode", "desc": "rueckgabewert gibt das Verhalten der Gueter an."},
        }
    },
    "EEPSetCamera": {
        "params": {
            1: {"type": "EEPCameraType", "desc": "parameter ist der Kameratyp."},
        }
    },
    "EEPGetPerspectiveCamera": {
        "returns": {
            2: {"type": "EEPPerspectiveCameraPosition", "desc": "rueckgabewert ist die Kameraposition."},
        }
    },
    "EEPGetTrainFromTrainyard": {
        "params": {
            4: {
                "type": "EEPTrainyardDepartureOrientation",
                "desc": "optionale 4. Parameter bestimmt die Ausrichtung des Zuges beim Ausfahren aus dem Depot.",
            },
        }
    },
    "EEPGetTrainyardItemStatus": {
        "returns": {
            1: {"type": "EEPTrainyardItemStatus", "desc": 'rueckgabewert ist der Status des "Fahrzeugverbands".'},
        }
    },
    "EEPShowInfoTextTop": {
        "params": {
            6: {"type": "EEPInfoTextAlignment", "desc": "parameter bestimmt die Textausrichtung."},
        }
    },
    "EEPShowInfoTextBottom": {
        "params": {
            6: {"type": "EEPInfoTextAlignment", "desc": "parameter bestimmt die Textausrichtung."},
        }
    },
    "EEPGetCloudsMode": {
        "returns": {
            1: {"type": "EEPCloudMode", "desc": "rueckgabewert gibt den Wolken-Modus an."},
        }
    },
    "EEPSetZoneClouds": {
        "params": {
            2: {"type": "EEPCloudMode", "desc": "parameter bestimmt den Wolken-Modus."},
        }
    },
    "EEPGetZoneClouds": {
        "returns": {
            2: {"type": "EEPCloudMode", "desc": "rueckgabewert gibt den Wolken-Modus an."},
        }
    },
    "EEPSetSeason": {
        "params": {
            1: {"type": "EEPSeason", "desc": "parameter ist die in der Anlage einzustellende Jahreszeit."},
        }
    },
    "EEPGetSeason": {
        "returns": {
            1: {"type": "EEPSeason", "desc": "rueckgabewert ist die in der Anlage eingestellte Jahreszeit."},
        }
    },
}


GENERIC_ENGLISH_PARAM_NAMES: dict[str, str] = {
    "stunde": "hour",
    "speichernummer": "storageSlot",
    "gleisID": "railTrackId",
    "strassenID": "roadTrackId",
    "strassenbahngleisID": "tramTrackId",
    "wegID": "auxiliaryTrackId",
    "steuerstreckenID": "controlTrackId",
    "splineID": "auxiliaryTrackId",
    "flaechennummer": "surfaceNumber",
    "achsnummer": "axisNumber",
    "achsengruppe": "axisGroup",
    "kranhakennummer": "hookNumber",
    "rueckruf": "invokeCallback",
    "quelle": "lightSource",
    "kupplungszustand": "couplingState",
    "zug_A": "trainNameA",
    "zug_B": "trainNameB",
    "zug_neu": "newTrainName",
    "zug_alt": "previousTrainName",
    "rot": "red",
    "gruen": "green",
    "blau": "blue",
    "rot_X": "rotX",
    "rot_Y": "rotY",
    "rot_Z": "rotZ",
    "kameraposition": "cameraPosition",
    "anlagenpfad": "projectPath",
    "booleanZahlZeichenkettenil": "value",
    "modus": "cloudMode",
    "windstaerke": "windIntensity",
    "schneefallstaerke": "snowIntensity",
    "nebeldichte": "fogIntensity",
    "name2": "newTrainName",
    "trainName2": "newTrainName",
}


ENTRY_PARAM_NAME_OVERRIDES: dict[str, dict[int, str]] = {
    "EEPPause": {1: "pauseStatus"},
    "EEPSetSignal": {2: "signalState", 3: "invokeCallback"},
    "EEPOnSignal_x": {1: "signalState"},
    "EEPGetSignalTrainName": {2: "trainIndex"},
    "EEPGetSignalFunction": {2: "selectionIndex"},
    "EEPGetSignalItemName": {2: "includeModelPath"},
    "EEPCheckSetRoute": {2: "routeTargetIndex"},
    "EEPSetSwitch": {2: "switchState", 3: "invokeCallback"},
    "EEPOnSwitch_x": {1: "switchState"},
    "EEPSetTrainRoute": {2: "routeName"},
    "EEPSetTrainLight": {2: "enabled", 3: "lightSource"},
    "EEPGetTrainLight": {2: "lightSource"},
    "EEPSetTrainSmoke": {2: "enabled"},
    "EEPSetTrainHorn": {2: "enabled"},
    "EEPSetTrainCouplingFront": {2: "couple"},
    "EEPSetTrainCouplingRear": {2: "couple"},
    "EEPTrainLooseCoupling": {3: "rollingstockCount", 4: "detachedTrainName"},
    "EEPOnTrainCoupling": {1: "movingTrainName", 2: "standingTrainName", 3: "combinedTrainName"},
    "EEPOnTrainLooseCoupling": {1: "retainedTrainName", 2: "detachedTrainName", 3: "originalTrainName"},
    "EEPSetTrainHook": {2: "enabled"},
    "EEPSetTrainHookGlue": {2: "fixedLoad"},
    "EEPSetTrainAxis": {3: "axisPosition", 4: "useNameFilter"},
    "EEPRollingstockSetAxis": {3: "axisPosition", 4: "useNameFilter"},
    "EEPRollingstockSetAxisByNumber": {2: "axisNumber", 3: "axisPosition"},
    "EEPRollingstockGetAxisByNumber": {2: "axisNumber"},
    "EEPRollingstockSetSlot": {2: "axisGroup"},
    "EEPGetRollingstockItemName": {2: "vehicleIndex"},
    "EEPRollingstockSetHook": {2: "enabled"},
    "EEPRollingstockSetHookGlue": {2: "fixedLoad"},
    "EEPRollingstockGetHookPosition": {2: "hookNumber"},
    "EEPRollingstockSetSmoke": {2: "enabled"},
    "EEPRollingstockSetHorn": {2: "enabled"},
    "EEPStructureGetSmoke": {1: "luaName"},
    "EEPStructureSetSmoke": {2: "enabled"},
    "EEPStructureGetLight": {1: "luaName"},
    "EEPStructureSetLight": {2: "enabled"},
    "EEPStructureGetFire": {1: "luaName"},
    "EEPStructureSetFire": {2: "enabled"},
    "EEPStructureSetAxis": {3: "axisPosition"},
    "EEPStructureSetAxisByNumber": {2: "axisNumber", 3: "axisPosition"},
    "EEPStructureGetAxisByNumber": {2: "axisNumber"},
    "EEPStructureAnimateAxis": {3: "stepDelta"},
    "EEPStructureSetLightningColour": {2: "red", 3: "green", 4: "blue"},
    "EEPGoodsSetAxis": {3: "axisPosition"},
    "EEPGoodsSetAxisByNumber": {2: "axisNumber", 3: "axisPosition"},
    "EEPGoodsGetAxisByNumber": {2: "axisNumber"},
    "EEPRegisterRailTrack": {1: "railTrackId"},
    "EEPIsRailTrackReserved": {1: "railTrackId", 2: "occupiedIndex"},
    "EEPRegisterRoadTrack": {1: "roadTrackId"},
    "EEPIsRoadTrackReserved": {1: "roadTrackId", 2: "occupiedIndex"},
    "EEPRegisterTramTrack": {1: "tramTrackId"},
    "EEPIsTramTrackReserved": {1: "tramTrackId", 2: "occupiedIndex"},
    "EEPRegisterAuxiliaryTrack": {1: "auxiliaryTrackId"},
    "EEPIsAuxiliaryTrackReserved": {1: "auxiliaryTrackId", 2: "occupiedIndex"},
    "EEPRegisterControlTrack": {1: "controlTrackId"},
    "EEPIsControlTrackReserved": {1: "controlTrackId", 2: "occupiedIndex"},
    "EEPRailTrackChangeAppearance": {1: "railTrackId", 2: "appearanceLevel"},
    "EEPRoadTrackChangeAppearance": {1: "roadTrackId", 2: "appearanceLevel"},
    "EEPTramTrackChangeAppearance": {1: "tramTrackId", 2: "appearanceLevel"},
    "EEPAuxiliaryTrackChangeAppearance": {1: "auxiliaryTrackId", 2: "appearanceLevel"},
    "EEPOnSaveAnl": {1: "projectPath"},
    "EEPGetTrainyardItemName": {2: "depotSlot"},
    "EEPGetTrainyardItemStatus": {3: "depotSlot"},
    "EEPShowInfoStructure": {2: "visible"},
    "EEPShowInfoSignal": {2: "visible"},
    "EEPShowInfoSwitch": {2: "visible"},
    "EEPShowInfoTextTop": {1: "red", 2: "green", 3: "blue", 4: "textSize", 6: "alignment"},
    "EEPShowInfoTextBottom": {1: "red", 2: "green", 3: "blue", 4: "textSize", 6: "alignment"},
    "EEPShowScrollInfoTextTop": {1: "red", 2: "green", 3: "blue", 4: "textSize", 6: "alignment", 7: "scrollSpeed"},
    "EEPShowScrollInfoTextBottom": {
        1: "red",
        2: "green",
        3: "blue",
        4: "textSize",
        6: "alignment",
        7: "scrollSpeed",
    },
    "EEPStructurePlaySound": {1: "luaName", 2: "enabled"},
    "EEPSetWindIntensity": {1: "windIntensity"},
    "EEPSetSnowIntensity": {1: "snowIntensity"},
    "EEPSetFogIntensity": {1: "fogIntensity"},
    "EEPSetZoneWindIntensity": {2: "windIntensity"},
    "EEPSetZoneSnowIntensity": {2: "snowIntensity"},
    "EEPSetZoneFogIntensity": {2: "fogIntensity"},
    "EEPSetZoneClouds": {2: "cloudMode"},
    "EEPSetTrainName": {2: "newTrainName"},
    "EEPSetPerspectiveCamera": {1: "cameraPosition"},
}


def apply_english_param_names(params: list[dict[str, object]], entry: Entry) -> None:
    entry_overrides = ENTRY_PARAM_NAME_OVERRIDES.get(entry.name, {})
    for index, param in enumerate(params, start=1):
        override = entry_overrides.get(index)
        if override:
            param["name"] = override
            continue
        name = str(param["name"])
        desc = str(param["desc"]).lower()
        if name == "name" and ("lua-name" in desc or "objekteigenschaften" in desc):
            param["name"] = "luaName"
            continue
        renamed = GENERIC_ENGLISH_PARAM_NAMES.get(name)
        if renamed:
            param["name"] = renamed


def apply_param_overrides(params: list[dict[str, object]], entry: Entry) -> None:
    overrides = {
        "EEPSetTrainSpeed": {
            3: {"name": "useTargetSpeed"},
        },
        "EEPGetTrainSpeed": {
            2: {"name": "useTargetSpeed"},
        },
        "EEPGetTrainFromTrainyard": {
            3: {"name": "depotSlot", "type": "number"},
            4: {
                "name": "departureOrientation",
            },
        },
    }
    entry_overrides = overrides.get(entry.name)
    if entry_overrides:
        for index, fields in entry_overrides.items():
            if 1 <= index <= len(params):
                param = params[index - 1]
                for key, value in fields.items():
                    param[key] = value
    alias_overrides = ENTRY_TYPE_OVERRIDES.get(entry.name, {}).get("params", {})
    for index, fields in alias_overrides.items():
        if 1 <= index <= len(params):
            param = params[index - 1]
            for key, value in fields.items():
                param[key] = value


def apply_return_overrides(returns: list[dict[str, str]], entry: Entry) -> None:
    alias_overrides = ENTRY_TYPE_OVERRIDES.get(entry.name, {}).get("returns", {})
    for index, fields in alias_overrides.items():
        if 1 <= index <= len(returns):
            ret = returns[index - 1]
            for key, value in fields.items():
                ret[key] = str(value)


def render_aliases(entry: Entry, emitted_aliases: set[str]) -> list[str]:
    aliases: list[str] = []
    entry_overrides = ENTRY_TYPE_OVERRIDES.get(entry.name, {})
    used_aliases: list[str] = []
    for kind in ("params", "returns"):
        for fields in entry_overrides.get(kind, {}).values():
            alias_name = fields.get("type")
            if isinstance(alias_name, str) and alias_name in ALIAS_DEFINITIONS and alias_name not in used_aliases:
                used_aliases.append(alias_name)
    for alias_name in used_aliases:
        if alias_name in emitted_aliases:
            continue
        if aliases:
            aliases.append("")
        aliases.extend(ALIAS_DEFINITIONS[alias_name])
        emitted_aliases.add(alias_name)
    return aliases


def parse_params(entry: Entry) -> list[dict[str, object]]:
    bullets = collect_bullets(entry.fields.get("Bemerkungen", []))
    params_by_index: dict[int, dict[str, object]] = {}
    next_index = 1
    last_param_index: int | None = None
    hints = extract_signature_hints(entry)
    for bullet in bullets:
        normalized_bullet = strip_sub_bullet_prefix(bullet)
        lower = normalized_bullet.lower()
        if "parameter" not in lower or "parameternamen" in lower:
            if last_param_index is not None and is_sub_bullet(bullet):
                params_by_index[last_param_index]["desc"] = clean_text(
                    f"{params_by_index[last_param_index]['desc']} {short_desc(normalized_bullet)}"
                )
            continue
        range_match = extract_param_range(normalized_bullet)
        if range_match:
            start, end = range_match
            group_names = infer_group_param_names(normalized_bullet, start, end)
            group_desc = clean_text(normalized_bullet)
            group_desc = group_desc[:1].lower() + group_desc[1:] if group_desc else "Parameter."
            for offset, index in enumerate(range(start, end + 1)):
                hint_name = hints[index - 1] if index - 1 < len(hints) else ""
                name = hint_name or group_names[offset]
                params_by_index[index] = {
                    "name": name,
                    "type": infer_type(normalized_bullet),
                    "optional": False,
                    "desc": group_desc,
                }
                last_param_index = index
            next_index = max(next_index, end + 1)
            continue
        if not is_param_bullet(normalized_bullet):
            if last_param_index is not None and is_sub_bullet(bullet):
                params_by_index[last_param_index]["desc"] = clean_text(
                    f"{params_by_index[last_param_index]['desc']} {short_desc(normalized_bullet)}"
                )
            continue
        index = extract_param_index(normalized_bullet, next_index)
        next_index = max(next_index, index + 1)
        params_by_index[index] = {
            "name": infer_param_name(normalized_bullet, index),
            "type": infer_type(normalized_bullet),
            "optional": "optional" in lower or "weggelassen" in lower,
            "desc": short_desc(normalized_bullet),
        }
        last_param_index = index
    if entry.name == "print":
        return [{"name": "...", "type": "any", "optional": False, "desc": "Auszugebende Werte."}]
    count_candidates = count_candidates_for_entry(entry, "Parameter")
    required_count = min(count_candidates) if count_candidates else len(params_by_index)
    expected_count = max(count_candidates) if count_candidates else max(params_by_index.keys(), default=0)
    for index, hint in enumerate(hints, start=1):
        if index in params_by_index:
            current_name = str(params_by_index[index]["name"])
            if hint and (current_name.startswith("param") or current_name in {"name", "text", "axisName2", "luaName"}):
                params_by_index[index]["name"] = hint
            continue
        if not hint or index > expected_count:
            continue
        params_by_index[index] = {
            "name": hint,
            "type": infer_type_from_hint(hint),
            "optional": index > required_count,
            "desc": "Parameter.",
        }
    params = [params_by_index[index] for index in sorted(params_by_index)]
    apply_param_hints_from_examples(params, entry)
    apply_param_overrides(params, entry)
    apply_english_param_names(params, entry)
    apply_param_type_hints_from_names(params)
    return uniquify_params(params)


def parse_returns(entry: Entry) -> list[dict[str, str]]:
    if entry.name == "print":
        return [{"name": "text", "type": "any", "desc": "rueckgabewert ist der komplette, ausgegebene String."}]

    bullets = collect_bullets(entry.fields.get("Bemerkungen", []))
    returns: list[dict[str, str]] = []
    last_return_index: int | None = None
    for bullet in bullets:
        lower = bullet.lower()
        if "keinen rueckgabewert" in lower:
            return []
        if "rueckgabewert" not in lower:
            if last_return_index is not None and is_sub_bullet(bullet):
                returns[last_return_index - 1]["desc"] = clean_text(
                    f"{returns[last_return_index - 1]['desc']} {short_desc(bullet)}"
                )
            continue
        if not RETURN_BULLET_RE.match(bullet):
            if last_return_index is not None and is_sub_bullet(bullet):
                returns[last_return_index - 1]["desc"] = clean_text(
                    f"{returns[last_return_index - 1]['desc']} {short_desc(bullet)}"
                )
            continue
        index = extract_return_index(bullet, len(returns) + 1)
        returns.append(
            {
                "name": infer_return_name(bullet, index),
                "type": "boolean" if index == 1 and "true" in lower and "false" in lower else infer_type(bullet),
                "desc": short_desc(bullet),
            }
        )
        last_return_index = index
    if not returns:
        count_candidates = count_candidates_for_entry(entry, "Rueckgabewerte")
        expected_count = max(count_candidates) if count_candidates else 0
        if expected_count > 0:
            fallback_lines = []
            for bullet in bullets:
                lower = bullet.lower()
                if "keinen rueckgabewert" in lower:
                    return []
                if "zurueck" in lower or "rueckgabewert" in lower:
                    fallback_lines.append(bullet)
            if fallback_lines:
                desc = short_desc(" ".join(fallback_lines))
                returns.append(
                    {
                        "name": infer_return_name(desc, 1),
                        "type": infer_type(desc),
                        "desc": desc,
                    }
                )
    apply_return_hints_from_examples(returns, entry)
    apply_return_overrides(returns, entry)
    return returns


def parse_notes(entry: Entry) -> list[str]:
    notes: list[str] = []
    previous_consumed = False
    for bullet in collect_bullets(entry.fields.get("Bemerkungen", [])):
        lower = bullet.lower()
        if "parameter" in lower and (is_param_bullet(bullet) or extract_param_range(bullet) is not None):
            previous_consumed = True
            continue
        if "rueckgabewert" in lower and RETURN_BULLET_RE.match(bullet):
            previous_consumed = True
            continue
        if previous_consumed and is_sub_bullet(bullet):
            continue
        previous_consumed = False
        notes.append(clean_text(bullet))
    return notes


def infer_variable_type(entry: Entry) -> str:
    text = f"{purpose_text(entry)} {' '.join(entry.fields.get('Bemerkungen', []))}".lower()
    if "ger =" in text or "eng =" in text or "fra =" in text or "sprache" in text:
        return "string"
    if "true" in text or "false" in text:
        return "boolean"
    return "number"


def placeholder(type_name: str) -> str:
    if type_name == "string":
        return '""'
    if type_name == "boolean":
        return "false"
    return "0"


def wrap_doc(text: str, prefix: str) -> list[str]:
    return textwrap.wrap(
        text,
        width=WRAP_WIDTH,
        initial_indent=prefix,
        subsequent_indent="--- " if prefix.startswith("---@") else prefix[:3],
        break_long_words=False,
        break_on_hyphens=False,
    ) or [prefix.rstrip()]


def wrap_comment(text: str, indent: int = 0) -> list[str]:
    prefix = "-- " + (" " * indent)
    return textwrap.wrap(
        text,
        width=WRAP_WIDTH,
        initial_indent=prefix,
        subsequent_indent=prefix,
        break_long_words=False,
        break_on_hyphens=False,
    ) or [prefix.rstrip()]


def render_entry(entry: Entry, emitted_aliases: set[str]) -> list[str]:
    lines: list[str] = []
    purpose = purpose_text(entry)
    version = version_text(entry)
    examples = normalize_examples(entry.examples, entry.name)
    if purpose:
        lines.extend(wrap_doc(purpose, "---"))
    aliases = render_aliases(entry, emitted_aliases)
    if aliases:
        lines.extend(aliases)

    if entry.callable:
        params = parse_params(entry)
        returns = parse_returns(entry)
        notes = parse_notes(entry)
        required = [p for p in params if not p["optional"]]
        if params and len(required) != len(params):
            overload_params = ", ".join(f"{p['name']}: {p['type']}" for p in required if p["name"] != "...")
            return_count_candidates = count_candidates_for_entry(entry, "Rueckgabewerte")
            overload_return_items = returns
            if return_count_candidates and returns:
                overload_return_items = returns[: min(return_count_candidates)]
            overload_returns = ", ".join(r["type"] for r in overload_return_items) or "nil"
            if overload_params:
                lines.append(f"---@overload fun({overload_params}): {overload_returns}")
        for param in params:
            body = f"{param['name']}{'?' if param['optional'] else ''} {param['type']} {param['desc']}"
            lines.extend(wrap_doc(body, "---@param "))
        for ret in returns:
            body = f"{ret['type']} {ret['name']} {ret['desc']}"
            lines.extend(wrap_doc(body, "---@return "))
        signature = ", ".join(str(param["name"]) for param in params)
        function_sig = f"{entry.name}({signature})"
        lines.append(f"function {function_sig} end")
        lines.append("")
        lines.append(f"-- {' ' * (len('function ') - len('-- '))}{'=' * len(function_sig)}")
    else:
        type_name = infer_variable_type(entry)
        lines.append(f"---@type {type_name}")
        lines.append(f"{entry.name} = {placeholder(type_name)}")

    if version:
        lines.extend(wrap_comment(f"Verfügbar ab {version}."))
    if entry.callable and notes:
        lines.append("-- Bemerkungen:")
        for note in notes:
            lines.extend(wrap_comment(note, indent=2))
    if examples:
        lines.append("-- Beispielaufrufe:")
        for example in examples:
            if example.startswith("-- "):
                lines.append(f"--   {example[3:]}")
            else:
                lines.append(f"--   {example}")
    return lines


def render_block_separator(entry: Entry) -> str:
    label = f"{entry.name}()" if entry.callable else entry.name
    prefix = f"-- === {label} "
    if len(prefix) >= WRAP_WIDTH:
        return prefix.rstrip()
    return prefix + ("=" * (WRAP_WIDTH - len(prefix)))


def render_entries(entries: list[Entry]) -> str:
    output: list[str] = [
        "---@meta",
        "",
        "-- Automatisch erzeugt mit scripts/generate_eep_original_api.py",
        "",
    ]
    emitted_aliases: set[str] = set()
    for entry in entries:
        output.append(render_block_separator(entry))
        output.extend(render_entry(entry, emitted_aliases))
        output.append("")
    return ascii_text("\n".join(output).rstrip() + "\n")


def write_generated_output(path: Path, entries: list[Entry]) -> None:
    path.write_text(render_entries(entries), encoding="latin-1")


def main() -> int:
    entries = build_entries()

    write_generated_output(OUTPUT, entries)
    print(f"generated {OUTPUT}")
    print(f"entries: {len(entries)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
