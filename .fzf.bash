# Setup fzf
# ---------
if [[ ! "$PATH" == */home/olafs/bin/fzf/bin* ]]; then
  export PATH="$PATH:/home/olafs/bin/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/olafs/bin/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/olafs/bin/fzf/shell/key-bindings.bash"

