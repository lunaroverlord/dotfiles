# neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
mv nvim.appimage ~/bin/nvim
chmod +x ~/bin/nvim

# Python
curl https://pyenv.run | bash
pyenv install 3.11.8
pyenv global 3.11.8

cd .vim
python -m venv env
source env/bin/activate
pip install pynvim jupyter_client cairosvg plotly kaleido pnglatex pyperclip jupytext

# Lua
sudo apt install libmagickwand-dev
sudo apt install lua5.1 luarocks
luarocks install magick --local
