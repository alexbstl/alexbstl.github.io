#!/usr/bin/env bash
set -euo pipefail

SRC="$HOME/Documents/resume/resume_current"   # absolute symlink path
OUT="resume_current.pdf"                      # output filename

# ensure source exists
if [[ ! -e "$SRC" ]]; then
  echo "Error: Source '$SRC' does not exist." >&2
  exit 1
fi

# copy the file the symlink points to (not the symlink itself)
# -L follows symlinks
rsync -aL "$SRC" "./$OUT"

echo "Copied $(readlink -f "$SRC") -> $OUT"

