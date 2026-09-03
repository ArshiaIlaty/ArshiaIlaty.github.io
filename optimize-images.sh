#!/usr/bin/env bash
#
# optimize-images.sh — shrink the images/ folder for fast page loads.
#
# The repo currently ships ~132 MB of images (some single files >10 MB), which
# makes the GitHub Pages site slow. This script downsizes and re-compresses them
# in place-ish (originals backed up first). Run it locally on your Mac.
#
#   Requirements (install once):
#     brew install imagemagick   # provides `magick`
#     brew install webp          # optional, for `cwebp` (best savings)
#
#   Usage:
#     ./optimize-images.sh            # compress JP/PNG in place (keeps format)
#     ./optimize-images.sh --webp     # ALSO emit .webp copies next to originals
#
# What it does:
#   * Backs up images/ -> images_backup_<stamp>/ before touching anything.
#   * Resizes any image wider than MAX_WIDTH down to MAX_WIDTH.
#   * Strips EXIF/metadata and re-encodes JPEG at quality 82, PNG optimized.
#   * Leaves your HTML untouched — filenames stay the same (unless --webp).
#
# After running, eyeball the images/ folder, then `git add -A && git commit`.

set -euo pipefail

MAX_WIDTH=1600      # px; nothing on a personal site needs to be wider
JPEG_QUALITY=82
ROOT="$(cd "$(dirname "$0")" && pwd)"
IMG_DIR="$ROOT/images"
MAKE_WEBP=false
[[ "${1:-}" == "--webp" ]] && MAKE_WEBP=true

# Pick the ImageMagick entrypoint (v7 = `magick`, v6 = `convert`).
if command -v magick >/dev/null 2>&1; then
  IM=(magick)
elif command -v convert >/dev/null 2>&1; then
  IM=(convert)
else
  echo "ERROR: ImageMagick not found. Install with: brew install imagemagick" >&2
  exit 1
fi

if [[ ! -d "$IMG_DIR" ]]; then
  echo "ERROR: $IMG_DIR not found. Run this from the repo root." >&2
  exit 1
fi

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$ROOT/images_backup_$STAMP"
echo "Backing up images/ -> $(basename "$BACKUP")"
cp -R "$IMG_DIR" "$BACKUP"

before_bytes=$(du -sk "$IMG_DIR" | awk '{print $1}')

# Process JPEG and PNG only. HEIC is skipped (browsers can't render it anyway).
find "$IMG_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0 |
while IFS= read -r -d '' f; do
  ext="${f##*.}"; ext_lc="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"
  case "$ext_lc" in
    jpg|jpeg)
      "${IM[@]}" "$f" -auto-orient -resize "${MAX_WIDTH}>" -strip \
        -sampling-factor 4:2:0 -quality "$JPEG_QUALITY" "$f"
      ;;
    png)
      "${IM[@]}" "$f" -auto-orient -resize "${MAX_WIDTH}>" -strip \
        -define png:compression-level=9 "$f"
      ;;
  esac
  if $MAKE_WEBP && command -v cwebp >/dev/null 2>&1; then
    cwebp -quiet -q 82 "$f" -o "${f%.*}.webp"
  fi
  echo "  optimized: ${f#"$ROOT"/}"
done

after_bytes=$(du -sk "$IMG_DIR" | awk '{print $1}')
echo
echo "Done. images/ : $((before_bytes/1024)) MB -> $((after_bytes/1024)) MB"
echo "Backup kept at $(basename "$BACKUP") — delete it once you're happy:"
echo "  rm -rf \"$BACKUP\""
