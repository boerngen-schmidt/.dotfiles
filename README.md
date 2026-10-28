My dot files for my linux desktop setup

## Installing

The packages to link into `$HOME` are listed in `.stow-packages`
(one per line, `#` comments allowed). `stow.sh` links them with GNU stow:

```bash
./stow.sh            # stow all packages from .stow-packages
./stow.sh -n         # dry run: show what would happen
./stow.sh bash git   # stow only these packages
./stow.sh -D         # remove the links again
./stow.sh --help     # all options
```

The benstop Ansible playbook clones this repo to `~/workspace/personal/dotfiles`
and runs `stow.sh --target ~`.

`stow.sh` never links a whole directory (`--no-folding`): it creates real
directories and links only the files. Programs that write into a stowed
directory at runtime, like the shell's plugin and theme folders under
`~/.config/desktop`, then write into `$HOME`, not into this checkout.

## Desktop shell

The bar, notifications, OSD, lock screen, idle handling, polkit agent and
background come from Omarchy's Quickshell shell, forked once from
[basecamp/omarchy](https://github.com/basecamp/omarchy) **v4.0.6**
(`237f1b4`). It lives in the `desktop` package:

| Path | Content |
|---|---|
| `~/.local/share/desktop/shell` | the Quickshell config (`omarchy-launch-shell` starts it) |
| `~/.local/share/desktop/bin` | the `omarchy-*` scripts the shell, menu and bindings call |
| `~/.local/share/desktop/themes`, `default/` | themes and the templates `omarchy-theme-set` renders |
| `~/.config/desktop/shell.json` | bar layout, idle timeouts, `disabledPlugins` |
| `~/.local/state/desktop/current` | the applied theme and background |

Files were copied verbatim, then `tools/rebrand.sh` moved Omarchy's paths to
the desktop namespace (`OMARCHY_PATH` is `DESKTOP_SHELL_PATH`, set in
`uwsm/.config/uwsm/env`). The rebrand leaves plugin IDs, IPC targets and script
names unchanged. Upstream's `omarchy-update*`, `omarchy-install-*` and package
management scripts are left out, because benstop manages the system.

Apply a theme once on a new machine (no running shell needed):

```bash
DESKTOP_SHELL_PATH=~/.local/share/desktop PATH=~/.local/share/desktop/bin:$PATH \
  OMARCHY_THEME_HEADLESS=1 omarchy-theme-set tokyo-night
```

To see what changed upstream since the fork, rebrand a newer tag the same way
and diff it:

```bash
git clone --depth 1 --branch vX.Y.Z https://github.com/basecamp/omarchy.git /tmp/omarchy
tools/rebrand.sh /tmp/omarchy
diff -r /tmp/omarchy/shell desktop/.local/share/desktop/shell
diff -r /tmp/omarchy/bin desktop/.local/share/desktop/bin
```

### Local plugins

Where Omarchy assumes software benstop does not run, a plugin of our own
replaces the Omarchy panel. Each lives in its own package and loads from
`~/.config/desktop/plugins` as a third-party plugin; the Omarchy original stays
in the tree, unused.

| Package | Plugin | Replaces | Backend |
|---|---|---|---|
| `desktop-network` | `desktop.network` | `omarchy.network` | iwd and systemd-networkd instead of NetworkManager, through `desktop-network-*` in `~/.local/bin` |
| `desktop-power` | `desktop.power` | `omarchy.power` | TLP (`tlpctl` from tlp-pd) instead of power-profiles-daemon, through `desktop-power-profiles` |

Each started as a verbatim copy of the Omarchy panel (its manifest records
`"clonedFrom"`) and was ported in a separate commit. `shell.json`, the Hyprland
bindings (`Super+Ctrl+W`, `Super+Ctrl+P`) and the Omarchy menu point at the new
IDs. The root-owned network helpers and their sudoers rules come from benstop
(`docs/desktop_environment.adoc` there).

TLP owns the power profile: benstop sets `TLP_AUTO_SWITCH=1`, so TLP goes back
to its configured profile whenever the charger is connected or disconnected,
and a profile picked in the panel holds until then. Omarchy's battery service
still calls `omarchy-powerprofiles-set` on charger changes; without
`powerprofilesctl` that does nothing.

### Changes to Omarchy files

Keep these when taking over a newer upstream:

- `find -L` in `shell/services/PluginRegistry.qml`,
  `shell/services/hidden-entries.sh` and `bin/omarchy-plugin-catalog`. With
  `--no-folding` every installed file is a symlink, and plain `find -type f`
  skips symlinks, so the bar found no first-party plugins.
- The callers of the local plugins and helpers above: `shell.json`,
  `default/omarchy/omarchy-menu.jsonc`, `shell/plugins/menu/Menu.qml` and
  `MenuModel.js`, and the speedtest and wifiqr panels.

## Launcher

`Super+Space` opens walker, with elephant as its data provider (packages
`walker` and `elephant`). Omarchy v4 itself no longer uses walker; it stays
here for the launcher, the clipboard (`Super+Ctrl+V`) and the emoji picker
(`Super+Ctrl+E`).

Apps are ranked by what was launched for a query (`history = true` in
`elephant/.config/elephant/desktopapplications.toml`; the counts live in
`~/.cache/elephant/desktopapplications_history.gob`). After restarting elephant,
restart walker too (`omarchy-restart-walker`): it did not show the new ranking
until then.

The shell's own app list (`omarchy-menu toggle apps`) was tried next to walker
in October 2026; walker stayed.
