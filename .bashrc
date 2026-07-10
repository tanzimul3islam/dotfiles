### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/tanzimul/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
source ~/.sway-env 2>/dev/null || true

# opencode
export PATH=/home/tanzimul/.opencode/bin:$PATH

[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tanzimul/.x-cmd.root/local/data/pkg/sphere/X/tree.linux.x64.0/miniconda/v3.10.0+23.9.0-0/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tanzimul/.x-cmd.root/local/data/pkg/sphere/X/tree.linux.x64.0/miniconda/v3.10.0+23.9.0-0/etc/profile.d/conda.sh" ]; then
        . "/home/tanzimul/.x-cmd.root/local/data/pkg/sphere/X/tree.linux.x64.0/miniconda/v3.10.0+23.9.0-0/etc/profile.d/conda.sh"
    else
        export PATH="/home/tanzimul/.x-cmd.root/local/data/pkg/sphere/X/tree.linux.x64.0/miniconda/v3.10.0+23.9.0-0/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$PATH:$HOME/flutter/bin"
export PATH="$HOME/flutter/bin:$PATH"
