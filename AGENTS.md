# Dotfiles

GNU stow packages for one Arch laptop. `README.md` is the source of truth for
the layout, the Omarchy fork and its local changes; read its "Desktop shell"
section before touching `desktop`, `desktop-*` or `hyprland`.

System changes (packages, root helpers, sudoers rules, services) belong in the
benstop Ansible repo at `~/workspace/personal/benstop`, which also clones this
repo and runs `stow.sh`. A plugin that needs a package or a root helper is a
change in both repos.

## Changing the Omarchy fork

Treat the imported Omarchy tree under `desktop/.local/share/desktop` as
upstream: it should diff cleanly against a rebranded Omarchy release. To change
what a panel does, replace it with a local plugin, the way `desktop-network`
and `desktop-power` do:

1. Create the package `desktop-<name>` and add it to `.stow-packages`.
2. Commit a verbatim copy of the Omarchy panel to
   `desktop-<name>/.config/desktop/plugins/<name>/`.
3. Port it in a following commit: manifest `id` `desktop.<name>`, author,
   description and `"omarchy": {"clonedFrom": "omarchy.<name>"}`;
   `moduleName`, `ipcTarget` and the `IpcHandler` target `desktop.<name>`.
   Helpers go to `desktop-<name>/.local/bin/desktop-<name>-*`.
4. Point the callers at the new ID: `desktop/.config/desktop/shell.json`, the
   Hyprland bindings, and the Omarchy menu
   (`desktop/.local/share/desktop/default/omarchy/omarchy-menu.jsonc`,
   `desktop/.local/share/desktop/shell/plugins/menu/`).
5. Add the plugin to the README's "Local plugins" table.

When an Omarchy file itself has to change, keep the edit minimal and list the
file in the README's "Changes to Omarchy files", so the next upstream merge
keeps it.

## Stowed files are symlinks

`stow.sh` runs with `--no-folding`: every installed file is a symlink into this
checkout, inside real directories. Code that scans installed directories must
follow symlinks: `find -L … -type f`, or `[[ -f ]]`. A new file in a package
only appears in `$HOME` after `./stow.sh <package>`.

## Applying a change on the running desktop

The installed files link into the main checkout, so a change is live only once
it is on the checked-out branch.

| Changed | Apply with |
|---|---|
| Shell QML or a plugin | `omarchy-restart-shell` |
| Hyprland config | `hyprctl reload`, then check `hyprctl -j configerrors` |
| Elephant config | `systemctl --user restart elephant`, then `omarchy-restart-walker` |

The `omarchy-*` scripts live in `~/.local/share/desktop/bin`; prepend it to
`PATH` when a shell outside the desktop session lacks it. The shell logs to
the journal under the tag `omarchy-shell`.

## Commits

Short imperative subject without a prefix ("Port the power panel to TLP power
profiles"), one change per commit. Document behaviour changes in `README.md` in
the same branch; system-side documentation goes to benstop's `docs/`.
