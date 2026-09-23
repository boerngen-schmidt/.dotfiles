#!/usr/bin/env bash
# Link the packages listed in .stow-packages into the target directory with GNU stow.
# Used by hand and by the benstop Ansible playbook (playbooks/user.yml).
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
package_file="$repo_dir/.stow-packages"
target="$HOME"
action="--stow"
dry_run=()

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] [package...]

Stow the dotfiles packages into \$HOME. Without package arguments, the
packages listed in .stow-packages are used (one per line, # comments allowed).

Options:
  -n, --dry-run      Show what would happen without changing anything
  -D, --unstow       Remove the links instead of creating them
  -R, --restow       Remove and recreate the links (e.g. after renaming files)
  -t, --target DIR   Link into DIR instead of \$HOME
  -l, --list         Print the packages from .stow-packages and exit
  -h, --help         Show this help

Output: stow reports every new link as "LINK: ..." on stderr; if there is
no such line, nothing was changed. Exit code is non-zero on any error,
including conflicts with existing files.
EOF
}

read_packages() {
  if [[ ! -f "$package_file" ]]; then
    echo "error: $package_file not found" >&2
    exit 1
  fi
  sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$package_file" | grep -v '^$' || true
}

packages=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run) dry_run=(--simulate) ;;
    -D|--unstow)  action="--delete" ;;
    -R|--restow)  action="--restow" ;;
    -t|--target)
      [[ $# -ge 2 ]] || { echo "error: $1 needs a directory" >&2; exit 2; }
      target="$2"; shift ;;
    -l|--list)    read_packages; exit 0 ;;
    -h|--help)    usage; exit 0 ;;
    -*)           echo "error: unknown option $1" >&2; usage >&2; exit 2 ;;
    *)            packages+=("$1") ;;
  esac
  shift
done

if ! command -v stow >/dev/null 2>&1; then
  echo "error: stow is not installed (pacman -S stow)" >&2
  exit 1
fi

if [[ ${#packages[@]} -eq 0 ]]; then
  mapfile -t packages < <(read_packages)
fi

if [[ ${#packages[@]} -eq 0 ]]; then
  echo "error: no packages to stow" >&2
  exit 1
fi

for package in "${packages[@]}"; do
  if [[ ! -d "$repo_dir/$package" ]]; then
    echo "error: package directory $repo_dir/$package does not exist" >&2
    exit 1
  fi
done

exec stow --verbose=1 "${dry_run[@]}" --dir "$repo_dir" --target "$target" "$action" "${packages[@]}"
