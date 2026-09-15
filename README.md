# dotfiles

Personal configuration files for a Fedora Atomic + Sway + Wayland workstation.

## Contents

| Config | Location |
|---|---|
| Sway | `sway/config` |
| Waybar | `waybar/config.jsonc`, `waybar/style.css` |
| Rofi | `rofi/config.rasi` |
| Neovim (LazyVim) | `nvim/` |
| tmux | `.tmux.conf` |
| Alacritty | `alacritty.toml` |
| Zsh | `.zshrc` |
| k9s | `k9s/skin.yml` |
| mako | notifications |

## Setup

```bash
DOTFILES_DIR=$HOME/Repos/github.com/tanzimul3islam/dotfiles
cd $DOTFILES_DIR
./setup
```

The `setup` script creates symlinks for the configs listed above. Safe to re-run (skips existing).

### Distrobox

Run `./setup` inside a distrobox/toolbox (apt-based) and it only sets up the CLI side:
it installs zsh, tmux, ripgrep, fd, jq and the clipboard tools with apt. It also installs
neovim, fzf and k9s with mise, using `/etc/mise/config.toml`, a file that exists only
inside the container. Finally it links the configs and makes zsh the login shell.
It skips Sway, SDDM, GTK and fonts.

## Scripts

Utility scripts in `scripts/` are added to `$PATH` via `.zshrc`.
