#!/usr/bin/env bash
# Stow/Unstow all dotfile *packages* (top-level dirs) safely.
# Usage:
#   ./start.sh apply        # stow all packages into $HOME
#   ./start.sh dry-run      # preview without changing anything
#   ./start.sh delete       # unstow all packages (remove symlinks from $HOME)
#   ./start.sh restow       # restow (convenience: delete then apply)
#   TARGET=/some/dir ./start.sh apply   # optional custom target

set -euo pipefail

#---- config -------------------------------------------------------------------
TARGET="${TARGET:-$HOME}"
# Common things you typically don't want stowed if present inside packages.
# Adjust as needed or move these to a .stow-local-ignore file later.
STOW_IGNORE_REGEX='(?x)
  (^|/)(README(\.md)?|LICENSE(\.md)?|CHANGELOG(\.md)?)$ |
  (^|/)(Makefile|makefile)$                           |
  (^|/)(install-.*\.sh)$                              |
  (^|/)\.DS_Store$'

#---- helpers ------------------------------------------------------------------
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Collect top-level, non-hidden directories (each is a stow "package")
mapfile -t PACKAGES < <(find "$script_dir" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -printf '%f\n' | sort)

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
  echo "No packages found under: $script_dir" >&2
  exit 1
fi

stow_all() {
  local extra_flags=("$@")
  for pkg in "${PACKAGES[@]}"; do
    # -R: restow, -v: verbose
    stow -Rv -t "$TARGET" --ignore="$STOW_IGNORE_REGEX" "${extra_flags[@]}" "$pkg"
  done
}

unstow_all() {
  for pkg in "${PACKAGES[@]}"; do
    stow -Dv -t "$TARGET" --ignore="$STOW_IGNORE_REGEX" "$pkg"
  done
}

#---- commands -----------------------------------------------------------------
cmd="${1:-apply}"

case "$cmd" in
apply)
  cd "$script_dir"
  stow_all
  ;;
dry-run | preview)
  cd "$script_dir"
  stow_all -n
  ;;
delete | unstow)
  cd "$script_dir"
  unstow_all
  ;;
restow)
  cd "$script_dir"
  unstow_all
  stow_all
  ;;
*)
  echo "Unknown command: $cmd" >&2
  echo "Usage: $0 {apply|dry-run|delete|restow}" >&2
  exit 2
  ;;
esac
