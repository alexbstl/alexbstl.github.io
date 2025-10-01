#!/usr/bin/env bash
set -euo pipefail

# absolute symlink paths
SRC_RESUME="$HOME/Documents/resume/resume_current"
SRC_CV="$HOME/Documents/resume/cv_current"

# output filenames
OUT_RESUME="resume_current.pdf"
OUT_CV="cv_current.pdf"

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

# Copy both
copy_symlink_target "$SRC_RESUME" "$OUT_RESUME"
copy_symlink_target "$SRC_CV" "$OUT_CV"

