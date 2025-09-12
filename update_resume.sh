#!/usr/bin/env bash
set -euo pipefail

# Defaults (override with flags)
SRC="resume_current"         # symlink or file to copy FROM
OUT="resume_current.pdf"     # file to copy TO
MSG=""                       # commit message (auto-filled if empty)
PUSH=1                       # 1 = push, 0 = don't push

usage() {
  cat <<EOF
Usage: $0 [-s SRC] [-o OUT] [-m MESSAGE] [--no-push]

Copies the target of a symlink (default: resume_current) to a real file
(default: resume_current.pdf), commits if changed, and pushes.

Options:
  -s, --src <path>        Source symlink/file (default: resume_current)
  -o, --out <path>        Output file (default: resume_current.pdf)
  -m, --message <text>    Commit message (auto if omitted)
      --no-push           Do not push after committing
  -h, --help              Show this help
EOF
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--src) SRC="$2"; shift 2 ;;
    -o|--out) OUT="$2"; shift 2 ;;
    -m|--message) MSG="$2"; shift 2 ;;
    --no-push) PUSH=0; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

# Ensure we're in a git repo; move to repo root
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${REPO_ROOT}" ]]; then
  echo "Error: Not inside a git repository." >&2
  exit 1
fi
cd "$REPO_ROOT"

# Basic checks
if [[ ! -e "$SRC" ]]; then
  echo "Error: Source '$SRC' does not exist." >&2
  exit 1
fi

# Follow symlinks and copy to OUT (overwrite), preserving times/perm
# -aL = archive + follow symlinks
rsync -aL --inplace "$SRC" "$OUT"

# Decide if anything changed compared to HEAD/index
changed=0
# Untracked?
if ! git ls-files --error-unmatch "$OUT" >/dev/null 2>&1; then
  changed=1
else
  # Tracked but modified?
  if ! git diff --quiet -- "$OUT"; then
    changed=1
  fi
fi

if [[ "$changed" -eq 0 ]]; then
  echo "No changes in '$OUT'; nothing to commit."
  exit 0
fi

# Compose commit message if not provided
if [[ -z "$MSG" ]]; then
  # Try to show what the symlink points to for clarity
  TARGET_DESC="$SRC"
  if [[ -L "$SRC" ]]; then
    TARGET_DESC="$(readlink "$SRC")"
  fi
  MSG="Update ${OUT} from ${TARGET_DESC} ($(date -u '+%Y-%m-%d %H:%M:%S UTC'))"
fi

git add "$OUT"
git commit -m "$MSG"

if [[ "$PUSH" -eq 1 ]]; then
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  git push origin "$BRANCH"
  echo "Pushed to origin/$BRANCH."
else
  echo "Committed locally. Skipped push (use --no-push to control)."
fi

