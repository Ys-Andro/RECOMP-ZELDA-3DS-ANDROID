#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEFAULT_DEST="$ROOT/title_sources"
ARCHIVE="${TRIAEVUM_TITLE_SOURCE_ARCHIVE:-}"
SOURCE_DIR="${TRIAEVUM_TITLE_SOURCE_DIR:-}"
DEST="${TRIAEVUM_TITLE_SOURCE_DEST:-$DEFAULT_DEST}"

if [[ -n "$ARCHIVE" && -n "$SOURCE_DIR" ]]; then
  echo "Define solo TRIAEVUM_TITLE_SOURCE_ARCHIVE o TRIAEVUM_TITLE_SOURCE_DIR, no ambos." >&2
  exit 2
fi

rm -rf "$DEST"
mkdir -p "$DEST"

if [[ -n "$ARCHIVE" ]]; then
  test -f "$ARCHIVE" || { echo "No existe el archivo AOT: $ARCHIVE" >&2; exit 1; }
  WORK="$(mktemp -d)"
  trap 'rm -rf "$WORK"' EXIT
  case "$ARCHIVE" in
    *.zip) unzip -q "$ARCHIVE" -d "$WORK" ;;
    *.tar|*.tar.gz|*.tgz|*.tar.xz|*.tar.zst) tar -xf "$ARCHIVE" -C "$WORK" ;;
    *) echo "Archivo de fuentes no soportado; usa ZIP/TAR.*" >&2; exit 2 ;;
  esac
  MANIFEST="$(find "$WORK" -type f -name TITLE_SOURCE_MANIFEST.json -print -quit)"
  test -n "$MANIFEST" || { echo "El archivo no contiene TITLE_SOURCE_MANIFEST.json" >&2; exit 1; }
  SOURCE_DIR="$(dirname "$MANIFEST")"
fi

if [[ -z "$SOURCE_DIR" ]]; then
  echo "Define TRIAEVUM_TITLE_SOURCE_DIR o TRIAEVUM_TITLE_SOURCE_ARCHIVE." >&2
  exit 2
fi

SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"
MANIFEST="$SOURCE_DIR/TITLE_SOURCE_MANIFEST.json"
test -f "$MANIFEST" || { echo "Falta $MANIFEST" >&2; exit 1; }

python3 - "$SOURCE_DIR" "$DEST" <<'PY'
import hashlib, json, pathlib, shutil, sys
src = pathlib.Path(sys.argv[1]).resolve()
dst = pathlib.Path(sys.argv[2]).resolve()
meta = json.loads((src / "TITLE_SOURCE_MANIFEST.json").read_text(encoding="utf-8"))
if meta.get("format") != "triaevum_translated_title_source_v1":
    raise SystemExit("Unsupported translated source manifest")
files = meta.get("files")
if not isinstance(files, dict) or not files:
    raise SystemExit("Translated source inventory is empty")
for name, expected in files.items():
    p = (src / name).resolve()
    if p.parent != src or p.name != name or p.suffix not in {".cpp", ".h"}:
        raise SystemExit(f"Invalid translated source name: {name}")
    if not p.is_file():
        raise SystemExit(f"Missing translated source: {name}")
    actual = hashlib.sha256(p.read_bytes()).hexdigest()
    if actual.lower() != str(expected).lower():
        raise SystemExit(f"Translated source hash mismatch: {name}")
    shutil.copy2(p, dst / name)
shutil.copy2(src / "TITLE_SOURCE_MANIFEST.json", dst / "TITLE_SOURCE_MANIFEST.json")
print(f"Verified and staged {len(files)} translated AOT source files in {dst}")
PY

printf 'TITLE_SOURCE_DIR=%s\n' "$DEST"
