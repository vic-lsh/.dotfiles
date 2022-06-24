#!/bin/sh

setup_git {
    git config --global user.name vic-shihang-li
    git config --global user.email 40274755+vic-shihang-li@users.noreply.github.com
}

setup_config_symlink {
    ln -nfs $(pwd)/.config ~/.config
}

setup_usr_bin_dir {
    mkdir ~/bin
}

setup_neovim {
    prevdir=$(pwd)
    cd /tmp
    NEOVIM_RELEASE=https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb
    wget $NEOVIM_RELEASE
    tar xzvf nvim-linux64.tar.gz
    mv ./nvim-linux64/bin/nvim ~/bin/nvim
    cd $prevdir
}

setup_git
setup_config_symlink
setup_usr_bin_dir
setup_neovim
