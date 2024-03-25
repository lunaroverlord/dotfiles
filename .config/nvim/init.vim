set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
if match(v:progname, '--noplugin') != -1
    echo "--noplugin"
else
    luafile ~/.config/nvim/plugins.lua
endif

