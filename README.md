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
