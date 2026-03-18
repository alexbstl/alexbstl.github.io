#!/usr/bin/env bash
set -euo pipefail

RESUME_DIR="$HOME/Documents/resume"

copy_symlink_target () {
    local src="$1"
    local out="$2"

    if [[ ! -e "$src" ]]; then
        echo "Error: Source '$src' does not exist." >&2
        return 1
    fi

    rsync -aL "$src" "./$out"
    echo "Copied $(readlink -f "$src") -> $out"
}

# Find and copy all cv_current* and resume_current* symlinks
for symlink in "$RESUME_DIR"/cv_current* "$RESUME_DIR"/resume_current*; do
    [[ -L "$symlink" ]] || continue
    base="$(basename "$symlink")"
    copy_symlink_target "$symlink" "${base}.pdf"
done
