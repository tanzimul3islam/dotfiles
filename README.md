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

## Scripts

Utility scripts in `scripts/` are added to `$PATH` via `.zshrc`.
