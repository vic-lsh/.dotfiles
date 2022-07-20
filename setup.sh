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
    NEOVIM_RELEASE=https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
    prevdir=$(pwd)
    cd /tmp
    wget $NEOVIM_RELEASE
    tar xzvf nvim-linux64.tar.gz
    mv ./nvim-linux64 ~/bin/nvim-linux64
    echo "PATH=$PATH:~/bin/nvim-linux64/bin" >> ~/.bash_profile
    . ~/.bash_profile
    setup_vimplug
    cd $prevdir
}

setup_clangd() {
    CLANGD_RELEASE=https://github.com/clangd/clangd/releases/download/14.0.3/clangd-linux-14.0.3.zip
    RELEASE_FILE=clangd-linux-14.0.3.zip
    RELEASE_DIR=clangd_14.0.3
    prevdir=$(pwd)
    cd /tmp
    wget $CLANGD_RELEASE
    unzip -o $RELEASE_FILE
    mv $RELEASE_DIR ~/bin/$RELEASE_DIR
    echo "PATH=$PATH:~/bin/$RELEASE_DIR/bin" >> ~/.bash_profile
    . ~/.bash_profile
    cd $prevdir
}

setup_tmux() {
    ln -s $(pwd)/.config/tmux/tmux.conf ~/.tmux.conf
}

patch_sh_profile() {
    echo "source ~/.bashrc" >> ~/.bash_profile
}

setup_git
setup_config_symlink
setup_usr_bin_dir
setup_neovim
setup_clangd
setup_tmux
patch_sh_profile
