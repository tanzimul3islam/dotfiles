# ~/.zshrc — Fedora Atomic + Sway workstation
# Symlinked from $DOTFILES/.zshrc by ./setup

# ~~~~~~~~~~~~~~~ Environment ~~~~~~~~~~~~~~~~~~~~~~~~

export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox

export REPOS="$HOME/Repos"
export GITUSER="tanzimul3islam"
export GHREPOS="$REPOS/github.com/$GITUSER"
export DOTFILES="$GHREPOS/dotfiles"
export SCRIPTS="$DOTFILES/scripts"
export ZETTELKASTEN="$HOME/Zettelkasten" # used by scripts/zet, zkcount, ...

source ~/.sway-env 2>/dev/null || true

# ~~~~~~~~~~~~~~~ Path ~~~~~~~~~~~~~~~~~~~~~~~~

typeset -U path # dedupe
path=(
  $HOME/.local/bin
  $SCRIPTS
  $path
)
path=($^path(N-/)) # drop directories that don't exist
export PATH

# Generated completions live here. Added to fpath early because x-cmd runs
# compinit itself during boot, and that dump must already include this dir.
ZSH_COMPLETION_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
mkdir -p "$ZSH_COMPLETION_CACHE"
fpath=("$ZSH_COMPLETION_CACHE" $fpath)

# ~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt EXTENDED_HISTORY     # save timestamps
setopt SHARE_HISTORY        # share across sessions
setopt HIST_IGNORE_SPACE    # skip commands prefixed with a space
setopt HIST_IGNORE_ALL_DUPS # keep only the newest duplicate
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY          # show !! expansion before running

# ~~~~~~~~~~~~~~~ Options ~~~~~~~~~~~~~~~~~~~~~~~~

setopt AUTO_CD              # `dir` alone cds into it
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

# ~~~~~~~~~~~~~~~ Vi mode ~~~~~~~~~~~~~~~~~~~~~~~~

bindkey -v
export KEYTIMEOUT=1 # fast Esc into normal mode

bindkey '^R' history-incremental-search-backward
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search
bindkey '^?' backward-delete-char # backspace past insert point
bindkey '^W' backward-kill-word

# Edit the current command in $EDITOR with `v` in normal mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# ~~~~~~~~~~~~~~~ Tool init ~~~~~~~~~~~~~~~~~~~~~~~~

# x-cmd (provides az, terraform, minikube, miniconda)
[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X"

# mise (java, starship)
(( $+commands[mise] )) && eval "$(mise activate zsh)"

# conda (miniconda installed through x-cmd)
__conda_root="$HOME/.x-cmd.root/local/data/pkg/sphere/X/tree.linux.x64.0/miniconda/v3.10.0+23.9.0-0"
if [[ -x "$__conda_root/bin/conda" ]]; then
  __conda_setup="$("$__conda_root/bin/conda" shell.zsh hook 2>/dev/null)"
  if [[ $? -eq 0 ]]; then
    eval "$__conda_setup"
  elif [[ -f "$__conda_root/etc/profile.d/conda.sh" ]]; then
    . "$__conda_root/etc/profile.d/conda.sh"
  else
    path=("$__conda_root/bin" $path)
  fi
fi
unset __conda_root __conda_setup

# ~~~~~~~~~~~~~~~ Completion ~~~~~~~~~~~~~~~~~~~~~~~~

# Cache generated completions; regenerate when the binary is newer than the cache.
_zcomp_changed=0
_cache_completion() {
  local cmd=$1; shift
  (( $+commands[$cmd] )) || return 0
  local file="$ZSH_COMPLETION_CACHE/_$cmd"
  if [[ ! -s $file || ${commands[$cmd]:A} -nt $file ]]; then
    "$@" >| "$file" 2>/dev/null && _zcomp_changed=1
  fi
}
_cache_completion kubectl  kubectl completion zsh
_cache_completion helm     helm completion zsh
_cache_completion minikube minikube completion zsh
_cache_completion devpod   devpod completion zsh
_cache_completion mise     mise completion zsh
_cache_completion starship starship completions zsh
unfunction _cache_completion

zmodload zsh/complist
autoload -Uz compinit
# x-cmd usually ran compinit already; only (re)run it if it didn't, or if a
# completion was just generated (compinit rebuilds the dump when files change).
if (( ! $+functions[compdef] || _zcomp_changed )); then
  compinit
fi
unset _zcomp_changed

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' # case-insensitive, fuzzy on . _ -
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Navigate the completion menu with vi keys
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey '^[[Z' reverse-menu-complete # Shift+Tab

# fzf: Ctrl-T files, Alt-C cd, Ctrl-R fuzzy history (overrides the ^R above)
(( $+commands[fzf] )) && source <(fzf --zsh)

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~

alias v=nvim
alias t=tmux
alias c=clear
alias e=exit

alias ls='ls --color=auto'
alias la='ls -lathr'
alias grep='grep --color=auto'

alias dot='cd $DOTFILES'
alias scripts='cd $SCRIPTS'
alias repos='cd $REPOS'
alias ghrepos='cd $GHREPOS'
alias gr=ghrepos

alias gs='git status'
alias gp='git pull'

alias k=kubectl
alias kgp='kubectl get pods'

alias sub='az account set -s'
alias ds='devpod ssh'

alias fix-clipboard='sudo chcon -t container_file_t /run/user/1000/wayland-1'

# ~~~~~~~~~~~~~~~ Plugins (optional) ~~~~~~~~~~~~~~~~~~~~~~~~

# sudo rpm-ostree install zsh-autosuggestions zsh-syntax-highlighting
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ~~~~~~~~~~~~~~~ Prompt ~~~~~~~~~~~~~~~~~~~~~~~~

# Starship with the Pure preset ($DOTFILES/starship.toml -> ~/.config/starship.toml)
(( $+commands[starship] )) && eval "$(starship init zsh)"

# Syntax highlighting must be sourced last
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
