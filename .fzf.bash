# Setup fzf
# ---------
if [[ ! "$PATH" == */home/olafs/.vim/bundle/fzf/bin* ]]; then
  export PATH="$PATH:/home/olafs/.local/share/nvim/lazy/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/olafs/.local/share/nvim/lazy/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/olafs/.local/share/nvim/lazy/fzf/shell/key-bindings.bash"


