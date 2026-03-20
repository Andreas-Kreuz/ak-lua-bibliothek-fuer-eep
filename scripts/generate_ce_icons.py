#!/usr/bin/env python3
from __future__ import annotations

"""
Generiert die modernisierte Iconfamilie der Control Extension aus
`assets/img/ce-logo.svg`.

Ausgabedateien:
- `assets/favicon.ico`
- `assets/img/ce-logo-72.png`
- `assets/img/ce-logo-144.png`
- `apps/web-app/public/favicon.svg`
- `apps/web-app/public/favicon.ico`
- `apps/web-app/public/apple-touch-icon.png`
- `apps/web-app/public/icon-192.png`
- `apps/web-app/public/icon-512.png`
- `apps/web-server/resources/icon.png`
- `apps/web-server/resources/icon.ico`
- `apps/web-server/resources/icon.icns` (nur auf macOS mit `iconutil`)

Voraussetzungen:
- Python-Paket `cairosvg` zum Rendern von SVG nach PNG
- Python-Paket `Pillow` zum Erzeugen von `.ico`
- auf macOS optional `iconutil` fuer `.icns`

Beispiel:
    python scripts/generate_ce_icons.py
"""

import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE_SVG = ROOT / "assets" / "img" / "ce-logo.svg"

PNG_OUTPUTS: list[tuple[Path, int]] = [
    (ROOT / "assets" / "img" / "ce-logo-72.png", 72),
    (ROOT / "assets" / "img" / "ce-logo-144.png", 144),
    (ROOT / "apps" / "web-app" / "public" / "apple-touch-icon.png", 180),
    (ROOT / "apps" / "web-app" / "public" / "icon-192.png", 192),
    (ROOT / "apps" / "web-app" / "public" / "icon-512.png", 512),
    (ROOT / "apps" / "web-server" / "resources" / "icon.png", 1024),
]

ICO_OUTPUTS: list[tuple[Path, list[int]]] = [
    (ROOT / "assets" / "favicon.ico", [16, 24, 32, 48]),
    (ROOT / "apps" / "web-app" / "public" / "favicon.ico", [16, 24, 32, 48]),
    (ROOT / "apps" / "web-server" / "resources" / "icon.ico", [16, 24, 32, 48, 64, 128, 256]),
]

SVG_COPIES: list[Path] = [
    ROOT / "apps" / "web-app" / "public" / "favicon.svg",
]

ICNS_OUTPUT = ROOT / "apps" / "web-server" / "resources" / "icon.icns"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generiert die Control-Extension-Icondateien.")
    parser.add_argument(
        "--source",
        type=Path,
        default=SOURCE_SVG,
        help="Quelldatei als SVG. Standard: assets/img/ce-logo.svg",
    )
    parser.add_argument(
        "--skip-icns",
        action="store_true",
        help="Erzeugt keine macOS-.icns-Datei.",
    )
    return parser.parse_args()


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def import_cairosvg():
    try:
        import cairosvg
    except ImportError as exc:  # pragma: no cover - depends on local env
        raise SystemExit(
            "Fehlende Abhaengigkeit: cairosvg. Installiere sie mit "
            "`python -m pip install cairosvg`."
        ) from exc
    return cairosvg


def import_pillow_image():
    try:
        from PIL import Image
    except ImportError as exc:  # pragma: no cover - depends on local env
        raise SystemExit(
            "Fehlende Abhaengigkeit: Pillow. Installiere sie mit "
            "`python -m pip install Pillow`."
        ) from exc
    return Image


def render_png(cairosvg, svg_bytes: bytes, target: Path, size: int) -> None:
    ensure_parent(target)
    cairosvg.svg2png(
        bytestring=svg_bytes,
        write_to=str(target),
        output_width=size,
        output_height=size,
    )


def copy_svg(source: Path, target: Path) -> None:
    ensure_parent(target)
    shutil.copyfile(source, target)


def build_ico(cairosvg, Image, svg_bytes: bytes, target: Path, sizes: list[int]) -> None:
    ensure_parent(target)
    largest = max(sizes)
    with tempfile.TemporaryDirectory(prefix="ce-icon-ico-") as temp_dir:
        temp_png = Path(temp_dir) / f"icon-{largest}.png"
        render_png(cairosvg, svg_bytes, temp_png, largest)
        image = Image.open(temp_png)
        try:
            image.save(target, format="ICO", sizes=[(size, size) for size in sizes])
        finally:
            image.close()


def build_icns(cairosvg, svg_bytes: bytes, target: Path) -> None:
    iconutil = shutil.which("iconutil")
    if iconutil is None:  # pragma: no cover - depends on local env
        print("Hinweis: `iconutil` nicht gefunden. `icon.icns` wird uebersprungen.", file=sys.stderr)
        return

    iconset_sizes = {
        "icon_16x16.png": 16,
        "icon_16x16@2x.png": 32,
        "icon_32x32.png": 32,
        "icon_32x32@2x.png": 64,
        "icon_128x128.png": 128,
        "icon_128x128@2x.png": 256,
        "icon_256x256.png": 256,
        "icon_256x256@2x.png": 512,
        "icon_512x512.png": 512,
        "icon_512x512@2x.png": 1024,
    }

    ensure_parent(target)
    with tempfile.TemporaryDirectory(prefix="ce-iconset-") as temp_dir:
        iconset_dir = Path(temp_dir) / "ControlExtension.iconset"
        iconset_dir.mkdir(parents=True, exist_ok=True)
        for filename, size in iconset_sizes.items():
            render_png(cairosvg, svg_bytes, iconset_dir / filename, size)

        subprocess.run(
            [iconutil, "-c", "icns", str(iconset_dir), "-o", str(target)],
            check=True,
        )


def main() -> int:
    args = parse_args()
    source = args.source.resolve()
    if not source.is_file():
        raise SystemExit(f"SVG-Datei nicht gefunden: {source}")

    cairosvg = import_cairosvg()
    Image = import_pillow_image()
    svg_bytes = source.read_bytes()

    for target in SVG_COPIES:
        copy_svg(source, target)

    for target, size in PNG_OUTPUTS:
        render_png(cairosvg, svg_bytes, target, size)

    for target, sizes in ICO_OUTPUTS:
        build_ico(cairosvg, Image, svg_bytes, target, sizes)

    if not args.skip_icns:
        build_icns(cairosvg, svg_bytes, ICNS_OUTPUT)

    print("Control-Extension-Icons erzeugt.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
