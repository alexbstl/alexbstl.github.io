#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

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

# Remove previously-published "current" PDFs so stale tracks don't linger.
# (Dated archives like resume_2024_09.pdf are intentionally left untouched.)
rm -f ./cv_current*.pdf ./resume_current*.pdf

# Find and copy all cv_current* and resume_current* symlinks
for symlink in "$RESUME_DIR"/cv_current* "$RESUME_DIR"/resume_current*; do
    # Require a symlink whose target actually exists (skip dangling links)
    [[ -L "$symlink" && -e "$symlink" ]] || continue
    base="$(basename "$symlink")"
    # Skip the redundant "_current_general" duplicate ("_current" already covers it)
    [[ "$base" == *_current_general ]] && continue
    copy_symlink_target "$symlink" "${base}.pdf"
done
