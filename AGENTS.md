# AGENTS.md — dotfiles

## Overview

Personal dotfiles for a Fedora Atomic + Sway + Wayland workstation. Forked from
[mischavandenburg/dotfiles](https://github.com/mischavandenburg/dotfiles) and
heavily adapted. This is a **configuration repo**, not a code project — no tests,
no CI, no build system.

## Shell

- **Zsh** (no oh-my-zsh), vi mode. `.bashrc` is Rancher Desktop managed only.
- Key env vars: `$DOTFILES`, `$SCRIPTS`, `$REPOS`, `$GHREPOS`, `$ZETTELKASTEN`.
- Custom two-line prompt using `vcs_info` (not powerlevel10k), battery indicator in emoji.
- Duplicate `compinit` calls in `.zshrc` (lines ~240 and line 261) — a known wart.
- GPG+YubiKey: gpg-agent serves as SSH agent; agent launch guarded against dev containers.

## Setup (`./setup`)

Fedora Atomic only (`rpm-ostree`). Creates symlinks:

| Repo file | Target |
|---|---|
| `sway/config` | `~/.config/sway/config` |
| `alacritty.toml` | `~/.config/alacritty/alacritty.toml` |
| `waybar/config.jsonc` | `~/.config/waybar/config` |
| `waybar/style.css` | `~/.config/waybar/style.css` |
| `k9s/skin.yml` | `~/.config/k9s/skin.yml` |
| `rofi/config.rasi` | `~/.config/rofi/config.rasi` |
| `nvim/` | `~/.config/nvim` |
| `.tmux.conf` | `~/.tmux.conf` |
| `.zshrc` | `~/.zshrc` |
| `.bashrc` | `~/.bashrc` |
| `.inputrc` | `~/.inputrc` |

Run: `./setup` (safe to re-run, skips existing).

## Desktop (Sway)

- Sway configured with Hyprland-style keybindings (Super key).
- Super+Q terminal, Super+R app menu, Super+C kill, Super+[1-9] workspace switch.
- Waybar (bottom, gruvbox-themed), Rofi (gruvbox, rounded corners), mako notifications.
- Sway environment sourced via `~/.sway-env`.

## Neovim

LazyVim with ~42 plugins. Key plugins:
- **Java**: nvim-jdtls, springboot-nvim (`nvim/lua/config/jdtls.lua`)
- **Copilot**: bound to `C-]` to accept
- **Zettelkasten**: custom LazyVim spec in `nvim/lua/config/zettelkasten.lua`
- **Telescope**, **Treesitter**, **conform.nvim**, **snacks.nvim**, **no-neck-pain.nvim**
- Colorscheme: gruvbox-material.

## Scripts (`scripts/`)

58 utility scripts, added to `$PATH`. Some have macOS-specific deps:
- `gsed` (used by `big`, `present`, `shorts`, `small`, `multiedit`, `shorts`, `ticket`)
- `osascript` (used by `dnd`)
- Some scripts still reference original author's paths (`zksync`, `zkbackup`).

## Devcontainer / Codespaces

`.zshrc` guards against `$REMOTE_CONTAINERS`, `$CODESPACES`, `$DEVCONTAINER_TYPE`:
- Skips GPG+YubiKey SSH setup
- Adds `/home/vscode/.local/bin`, `/root/.local/bin` to PATH
- Sources Homebrew if `/home/linuxbrew/.linuxbrew` exists

## Other configs

- **tmux**: vi copy mode, mouse on, escape-time 10ms (nvim compat), history 25k, status bar on top, `pomo` in status-right.
- **Alacritty**: UbuntuMono Nerd Font size 17, no decorations.
- **k9s**: Nord-themed skin.
- **Git**: ignore `lazy-lock.json`, `.DS_Store`, `lazyvim.json`.
- **Kubernetes**: aliases `k` (kubectl), `kc` (kubectx), `kn` (kubens), `fgk` (flux get kustomizations).
