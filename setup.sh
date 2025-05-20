#!/bin/bash

# Global variables to count function calls and successes
TOTAL_FUNCTIONS_CALLED=0
TOTAL_FUNCTIONS_SUCCEEDED=0

# Higher-order function to call a setup function and handle errors
invoke_setup_fn() {
  local func=$1

  $func
  local status=$?

   ((TOTAL_FUNCTIONS_CALLED++))

  if [ $status -ne 0 ]; then
    echo "********* ERROR:   bash function '$func' exited with status $status *********"
  else
    echo "********* SUCCESS: bash function '$func' succeeded                  *********"
    ((TOTAL_FUNCTIONS_SUCCEEDED++))
  fi
}


setup_git() {
    git config --global user.name vic-lsh
    git config --global user.email 40274755+vic-shihang-li@users.noreply.github.com
}

setup_config_symlink() {
    ln -s $(pwd)/.config ~/.config
}

setup_usr_bin_dir() {
    mkdir -p ~/bin
}

setup_packer() {
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
		~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

setup_neovim() {
    NEOVIM_RELEASE=https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
    prevdir=$(pwd)
    cd /tmp
    wget $NEOVIM_RELEASE
    tar xzvf nvim-linux64.tar.gz
    mv ./nvim-linux64 ~/bin/nvim-linux64
    echo "PATH=$PATH:~/bin/nvim-linux64/bin" >> ~/.bash_profile
    . ~/.bash_profile
    setup_packer
    cd $prevdir
}

setup_clangd() {
    CLANGD_RELEASE=https://github.com/clangd/clangd/releases/download/15.0.6/clangd-linux-15.0.6.zip
    RELEASE_FILE=clangd-linux-15.0.6.zip
    RELEASE_DIR=clangd_15.0.6
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

install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    . "$HOME/.cargo/env"
}

install_rust_analyzer() {
    mkdir -p ~/.local/bin
    curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
    chmod +x ~/.local/bin/rust-analyzer
    echo "PATH=$PATH:~/.local/bin" >> ~/.bash_profile
    rustup component add rust-src
}

setup_rust() {
    install_rust && install_rust_analyzer
}

patch_bash_profile() {
    echo "if [ -f ~/.bashrc ]; then . ~/.bashrc; fi" >> ~/.bash_profile
}

invoke_setup_fn setup_git
invoke_setup_fn setup_config_symlink
invoke_setup_fn patch_bash_profile
invoke_setup_fn setup_usr_bin_dir
invoke_setup_fn setup_neovim
invoke_setup_fn setup_clangd
invoke_setup_fn setup_tmux
invoke_setup_fn setup_rust

source ~/.bash_profile

echo "Setup complete! [$TOTAL_FUNCTIONS_SUCCEEDED / $TOTAL_FUNCTIONS_CALLED] setup steps were successful."
