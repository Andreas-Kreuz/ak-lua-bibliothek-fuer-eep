#!/usr/bin/env python3
from __future__ import annotations

import re
import subprocess
import textwrap
import unicodedata
from dataclasses import dataclass, field
from pathlib import Path


PDFTOTEXT = Path(r"C:\Program Files\Git\mingw64\bin\pdftotext.exe")
ROOT = Path(__file__).resolve().parents[1]
MANUAL = ROOT / "Lua_manual.pdf"
OUTPUT = ROOT / "lua" / "LUA" / "ak" / "core" / "eep" / "EepOriginalApi.d.lua"
WRAP_WIDTH = 118

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


def extract_text() -> list[str]:
    if not PDFTOTEXT.exists():
        raise FileNotFoundError(f"pdftotext not found: {PDFTOTEXT}")
    if not MANUAL.exists():
        raise FileNotFoundError(f"manual not found: {MANUAL}")

    result = subprocess.run(
        [str(PDFTOTEXT), "-table", "-enc", "UTF-8", str(MANUAL), "-"],
        capture_output=True,
        check=True,
    )
    raw = result.stdout.decode("utf-8", errors="replace").replace("\r", "")
    lines = [line.replace("\x0c", "") for line in raw.split("\n")]

    start_index = 0
    for index, line in enumerate(lines):
        if clean_text(line) == "EEPVer":
            start_index = index
            break

    trimmed: list[str] = []
    for line in lines[start_index:]:
        if is_index_start(line):
            break
        trimmed.append(line)
    return trimmed


def is_entry_start(line: str) -> bool:
    return bool(ENTRY_NAME_RE.fullmatch(clean_text(line)))


def collect_blocks(lines: list[str]) -> list[list[str]]:
    blocks: list[list[str]] = []
    current: list[str] = []

    def has_meaningful_content(block: list[str]) -> bool:
        return any(clean_text(line) for line in block[1:])

    for line in lines:
        if current and is_block_terminator(line):
            if has_meaningful_content(current):
                blocks.append(current)
                current = []
            continue
        if is_entry_start(line):
            if current:
                blocks.append(current)
            current = [line]
            continue
        if current:
            current.append(line)
    if current and any(clean_text(line) for line in current[1:]):
        blocks.append(current)
    return blocks


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
    return text


def is_example_start(text: str) -> bool:
    lower = text.lower()
    if lower == "end":
        return True
    if lower.startswith(("if ", "elseif ", "else", "function ", "return ", "--")):
        return True
    if re.match(r"^[A-Za-z_][A-Za-z0-9_]*(?:\s*,\s*[A-Za-z_][A-Za-z0-9_]*)*\s*=", text):
        return True
    if re.match(r"^(EEP[A-Za-z0-9_]+|print|clearlog)\(", text):
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


def parse_variable_block(block: list[str]) -> Entry:
    name = clean_text(block[0])
    entry = Entry(name=name, callable=False)
    current_field: str | None = None
    saw_voraussetzung = False
    saw_zweck = False

    for raw_line in block[1:]:
        if is_noise(raw_line):
            continue
        parts = merge_prefix_parts(split_parts(raw_line))
        if not parts:
            continue
        if parts == [name] or parts == [name, name]:
            continue

        if parts[0] == "Voraussetzung":
            saw_voraussetzung = True
            current_field = "Voraussetzung"
            example_parts: list[str] = []
            for part in parts[1:]:
                if looks_like_version_piece(part) and not example_parts:
                    entry.add_field("Voraussetzung", part)
                else:
                    example_parts.append(part)
            example = join_example_parts(example_parts)
            if example:
                entry.add_example(example)
            continue

        if parts[0] == "Zweck":
            saw_zweck = True
            current_field = "Zweck"
            entry.add_field("Zweck", join_parts(parts[1:]))
            continue

        if not saw_voraussetzung:
            if looks_like_version_piece(parts[0]):
                entry.add_field("Voraussetzung", parts[0])
                example = join_example_parts(parts[1:])
                if example:
                    entry.add_example(example)
            elif entry.examples and previous_example_is_open(entry.examples[-1]):
                entry.add_example(join_parts(parts))
            else:
                example = join_example_parts(parts)
                if example:
                    entry.add_example(example)
            continue

        if current_field == "Voraussetzung" and not saw_zweck:
            if looks_like_version_piece(parts[0]):
                entry.add_field("Voraussetzung", parts[0])
                example = join_example_parts(parts[1:])
                if example:
                    entry.add_example(example)
                continue
            if is_example_start(join_parts(parts)) or is_example_continuation(join_parts(parts)):
                entry.add_example(join_parts(parts))
                continue
            current_field = "Zweck"
            saw_zweck = True
            entry.add_field("Zweck", join_parts(parts))
            continue

        if current_field == "Zweck":
            entry.add_field("Zweck", join_parts(parts))

    return entry


def parse_function_field_line(entry: Entry, label: str, parts: list[str]) -> None:
    if label in {"Parameter", "Rueckgabewerte"}:
        if parts and looks_like_count_fragment(parts[0]):
            entry.add_field(label, parts[0])
            example = join_example_parts(parts[1:])
            if example:
                entry.add_example(example)
            return
        example = join_example_parts(parts)
        if example:
            entry.add_example(example)
        return

    if label == "Voraussetzung":
        example_parts: list[str] = []
        for part in parts:
            if looks_like_version_piece(part) and not example_parts:
                entry.add_field("Voraussetzung", part)
            else:
                example_parts.append(part)
        example = join_example_parts(example_parts)
        if example:
            entry.add_example(example)
        return

    if label in {"Zweck", "Bemerkungen"}:
        cleaned = join_parts(parts)
        if cleaned.startswith("-"):
            entry.add_field("Bemerkungen", cleaned)
            return
        entry.add_field(label, cleaned)


def parse_function_block(block: list[str]) -> Entry:
    name = re.sub(r"\s*\(\s*\)\s*$", "", clean_text(block[0]))
    entry = Entry(name=name, callable=True)
    current_field: str | None = None

    for raw_line in block[1:]:
        if is_noise(raw_line):
            continue
        parts = merge_prefix_parts(split_parts(raw_line))
        if not parts:
            continue
        cleaned = join_parts(parts)

        if parts == [f"{name}()"] or parts == [name]:
            continue

        if parts[0] == f"{name}()":
            entry.signature_example = join_example_parts(parts[1:])
            if entry.signature_example:
                entry.add_example(entry.signature_example)
            continue

        if parts[0] in FIELD_SET:
            current_field = parts[0]
            parse_function_field_line(entry, current_field, parts[1:])
            continue

        if current_field in {"Parameter", "Rueckgabewerte", "Voraussetzung"} and looks_like_version_piece(parts[0]):
            entry.add_field("Voraussetzung", parts[0])
            example = join_example_parts(parts[1:])
            if example:
                entry.add_example(example)
            continue

        if current_field in {"Parameter", "Rueckgabewerte", "Voraussetzung"}:
            example = join_example_parts(parts)
            if current_field in {"Parameter", "Rueckgabewerte"} and looks_like_count_fragment(cleaned):
                entry.append_field_fragment(current_field, cleaned)
                continue
            if example and (
                is_example_start(example)
                or is_example_continuation(example)
                or (entry.examples and previous_example_is_open(entry.examples[-1]))
            ):
                entry.add_example(example)
                continue
            if current_field == "Voraussetzung":
                current_field = "Zweck"
                entry.add_field("Zweck", cleaned)
                continue
            if current_field in {"Parameter", "Rueckgabewerte"} and not is_count_word(cleaned):
                entry.add_field("Bemerkungen", cleaned)
            continue

        if current_field in {"Zweck", "Bemerkungen"}:
            if cleaned.startswith("-"):
                current_field = "Bemerkungen"
                entry.add_field("Bemerkungen", cleaned)
            else:
                entry.add_field(current_field, cleaned)
            continue

        if entry.examples and previous_example_is_open(entry.examples[-1]):
            entry.add_example(cleaned)
            continue

        if is_example_start(cleaned):
            entry.add_example(cleaned)

    return entry


def parse_block(block: list[str]) -> Entry:
    callable_block = any(clean_text(line).startswith(("Parameter", "Rueckgabewerte")) for line in block[1:])
    if callable_block:
        return parse_function_block(block)
    return parse_variable_block(block)


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
    if "fahrzeugverbands" in lower or "fahrzeugverband" in lower or "zugname" in lower:
        return "trainName"
    if "rollmaterials" in lower or "rollmaterial" in lower:
        return "rollingstockName"
    if "virtuellen depot" in lower or "virtuellen depots" in lower:
        return "depotId"
    if "signal-id" in lower or "signal id" in lower:
        return "signalId"
    if ("weiche" in lower or "weichen-id" in lower) and "id" in lower:
        return "switchId"
    if "wetterzone" in lower and ("nummer" in lower or "zonennummer" in lower):
        return "zoneId"
    if "name der achse" in lower:
        return "axisName"
    if "position, zu der sich die achse bewegen soll" in lower or "schrittzahl" in lower:
        return "position"
    if "zonenmittelpunktes" in lower and "x-richtung" in lower:
        return "posX"
    if "zonenmittelpunktes" in lower and "y-richtung" in lower:
        return "posY"
    if "zonenmittelpunktes" in lower and "z-richtung" in lower:
        return "posZ"
    if "radius der wetterzone" in lower:
        return "radius"
    if "route" in lower:
        return "route"
    if "text" in lower:
        return "text"
    if "geschwindigkeit" in lower:
        return "speed"
    if "wolken-modus" in lower or "modus" in lower:
        return "mode"
    if "lichtquelle" in lower or "quelle" in lower:
        return "quelle"
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
    if "lua-name" in lower or "name der immobilie" in lower or "name des ladeguts" in lower:
        return "name"
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
    hint = clean_text(text)
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
    if hint.lower() in {"truefalse", "falsetrue"}:
        return "state"
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
        return ["rot", "gruen", "blau"]
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
    if suffix.startswith(("--", ",", ")", "]")):
        return text
    if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", suffix):
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
        return False
    if curr.startswith("--") and not prev.startswith("--"):
        return False
    if is_example_start(prev) and is_example_start(curr):
        return False
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
        if not args_match:
            continue
        args = [sanitize_hint_name(part) for part in args_match.group(1).split(",")]
        hints = [arg for arg in args if arg]
        if hints:
            return hints
    return []


def apply_param_hints_from_examples(params: list[dict[str, object]], entry: Entry) -> None:
    hints = extract_signature_hints(entry)
    if not hints:
        return
    for param, hint in zip(params, hints):
        current_name = str(param["name"])
        if hint and (
            current_name.startswith("param")
            or current_name in {"stellung", "name", "state", "mode"}
            or (current_name.endswith("Name") and not hint.endswith("Name"))
        ):
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
            if current_name.startswith("param") or current_name in {"name", "text", "axisName2", "luaName"}:
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


def wrap_comment(text: str) -> list[str]:
    return textwrap.wrap(
        text,
        width=WRAP_WIDTH,
        initial_indent="-- ",
        subsequent_indent="-- ",
        break_long_words=False,
        break_on_hyphens=False,
    ) or ["--"]


def render_entry(entry: Entry) -> list[str]:
    lines: list[str] = []
    purpose = purpose_text(entry)
    version = version_text(entry)
    examples = normalize_examples(entry.examples, entry.name)
    if purpose:
        lines.extend(wrap_doc(purpose, "---"))

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
            lines.extend(wrap_comment(note))
    if examples:
        lines.append("-- Beispielaufrufe:")
        for example in examples:
            if example.startswith("-- "):
                lines.append(example)
            else:
                lines.append(f"-- {example}")
    return lines


def main() -> int:
    lines = extract_text()
    blocks = collect_blocks(lines)
    entries = [parse_block(block) for block in blocks]

    output: list[str] = [
        "---@meta",
        "",
        "-- Automatisch erzeugt mit scripts/generate_eep_original_api.py",
        "",
    ]
    for entry in entries:
        output.append("-- " + ("-" * (WRAP_WIDTH - 3)))
        output.extend(render_entry(entry))
        output.append("")

    rendered = ascii_text("\n".join(output).rstrip() + "\n")
    OUTPUT.write_text(rendered, encoding="latin-1")
    print(f"generated {OUTPUT}")
    print(f"entries: {len(entries)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
