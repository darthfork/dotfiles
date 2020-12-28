<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Vimlogo.svg/1200px-Vimlogo.svg.png" alt="dotfiles" width="150" height="150" />
</p>

### To update packages

```
git submodule update --remote --merge
```

### To setup neovim

```
mkdir -p ~/.config/nvim
mkdir -p ~/.local/share/nvim/
ln -s ~/.vim/vimrc ~/.config/nvim/init.vim
ln -s ~/.vim ~/.local/share/nvim/site
```
