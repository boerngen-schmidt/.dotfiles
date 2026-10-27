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
`uwsm/.config/uwsm/env`). Plugin IDs, IPC targets and script names are
unchanged. Upstream's `omarchy-update*`, `omarchy-install-*` and package
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
