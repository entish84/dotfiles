# dotfiles

### NVIM Instructions

rm -rfd ~/.local/share/nvim/
rm -rfd ~/.local/state/nvim 
rm -rfd ~/.cache/nvim
rm ~/.config/nvim/nvim-pack-lock.json
rm ~/.config/nvim/init.lua
touch ~/.config/nvim/init.lua

sudo rm -rfd /opt/nvim-linux-x86_64


mkdir -p ~/.config/nvim
cd ~/.config/nvim
touch init.lua
mkdir -p lua/config/
cd ~/.config/nvim/lua/config
touch {init,options,keymaps,diagnostics,autocmds}.lua

cp -ird ~/.config/nvim ~/Downloads/nvimempty

