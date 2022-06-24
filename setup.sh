#!/bin/sh

setup_git() {
    git config --global user.name vic-shihang-li
    git config --global user.email 40274755+vic-shihang-li@users.noreply.github.com
}

setup_config_symlink() {
    ln -s $(pwd)/.config ~/.config
}

setup_usr_bin_dir() {
    mkdir -p ~/bin
}

setup_vimplug() {
    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

setup_neovim() {
    prevdir=$(pwd)
    cd /tmp
    NEOVIM_RELEASE=https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
    wget $NEOVIM_RELEASE
    tar xzvf nvim-linux64.tar.gz
    mv ./nvim-linux64 ~/bin/nvim-linux64
    echo "PATH=$PATH:~/bin/nvim-linux64/bin" >> ~/.bash_profile
    setup_vimplug
    cd $prevdir
}

setup_git
setup_config_symlink
setup_usr_bin_dir
setup_neovim
