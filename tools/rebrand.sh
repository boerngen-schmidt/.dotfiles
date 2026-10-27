#!/usr/bin/env bash
# Rewrite Omarchy's install, state, config and cache paths to the desktop
# namespace used by these dotfiles. Plugin IDs (omarchy.menu, ...), IPC
# targets and script names are left alone so the tree stays diffable against
# upstream.
#
# Usage: tools/rebrand.sh [DIR...]
#   Without arguments, rewrites the imported tree in desktop/. To compare a
#   new upstream release, clone it and run this script on the clone first:
#
#     git clone --depth 1 --branch vX.Y.Z https://github.com/basecamp/omarchy.git /tmp/omarchy
#     tools/rebrand.sh /tmp/omarchy
#     diff -r /tmp/omarchy/shell desktop/.local/share/desktop/shell
#
# The rules are idempotent: running the script twice changes nothing.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
(($# > 0)) || set -- "$repo_dir/desktop"

rules=(
  # Install location, set by uwsm/.config/uwsm/env.
  's#\bOMARCHY_PATH\b#DESKTOP_SHELL_PATH#g'
  's#\.local/share/omarchy\b#.local/share/desktop#g'

  # Per-user state, config and cache.
  's#\.local/state/omarchy\b#.local/state/desktop#g'
  's#\.config/omarchy\b#.config/desktop#g'
  's#\.cache/omarchy\b#.cache/desktop#g'
  's#(state|config|cache)\}/omarchy\b#\1}/desktop#g'
  's#(stateHome|configHome|cacheHome) \+ "/omarchy\b#\1 + "/desktop#g'
  's#(\.local/state"\)) \+ "/omarchy\b#\1 + "/desktop#g'
)

sed_args=()
for rule in "${rules[@]}"; do
  sed_args+=(-e "$rule")
done

for dir in "$@"; do
  # Regular files only: sed -i would turn a symlink into a copy.
  find "$dir" -name .git -prune -o -type f -print0 |
    { xargs -0 grep -lIE 'omarchy|OMARCHY_PATH' || true; } |
    while IFS= read -r file; do
      sed -E -i "${sed_args[@]}" "$file"
    done
done
