mkdir ~/linux
git clone --separate-git-dir=$HOME/linux/dotfiles https://github.com/lunaroverlord/dotfiles $HOME/linux/dotfiles-tmp
rm -r ~/linux/dotfiles-tmp/
echo "alias config='/usr/bin/git --git-dir=$HOME/linux/dotfiles/ --work-tree=$HOME'" >> ~/.bashrc
