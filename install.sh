#!/bin/bash

FORCE_INSTALL=

dothome="$HOME/.dotfiles"
zhome="$dothome/zsh"
vhome="$dothome/vim"
thome="$dothome/tmux"
cdate=`date +%Y%m%d%H%M%S`

_repo="git@github.com:instilled/.dotfiles.git"
_brew=`which brew`

if [ ! -x "$_brew" ]; then
    echo "Sorry. I need 'brew' to continue."
    echo "You can install it by typing"
    echo '    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'
    echo "at your shell."
    exit 1
fi

if [ ! -d "/Applications/Xcode.app" ]; then
    echo "Please install 'xcode' first!"
    exit 1
fi

echo "Hi there. I'm your dotfiles and will install myself at ~/.dotfiles."
echo "To run smoothly I require 'reattach-to-user-namespace' and 'macvim'"
echo "be installed on your system. I'll do that for you and will succeed"
echo "if 'brew' and 'xcode' are available. Finally I'll create a few "
echo "symlinks in your home directory. Existing files will of course"
echo "be backed up for you."
echo

while true; do
    read -p "Is that ok? [y|n]: " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
    esac
done

# Clone the repo
echo "Cloning .dotfiles and initializing submodules..."
git clone $_repo "$dothome" &> /dev/null
(cd "$dothome" && git submodule update --init --recursive)
#(cd "$dothome" && git submodule update)

# Install brew dependencies
echo
echo "Installing brew dependencies..."
brew install \
  git \
  reattach-to-user-namespace \
  cmake \
  ctags \
  tmux \
  wget \
  mvn \
  coreutils \
  mc
brew install macvim --env-std --override-system-vim

function bkp() {
    echo "Baking up $HOME/$1 to $HOME/$1.bak.$cdate"
    if [ -a" $HOME/$1" ]; then
        mv "$HOME/$1" "$HOME/$1.bak.$cdate"
    fi
}

# ZSH
echo
echo "Installing zsh... ~/.zsh[,rc,env]"
bkp .zsh
ln -s "$zhome" "$HOME/.zsh"

bkp .zshrc
ln -s ".zsh/zshrc" "$HOME/.zshrc"

bkp .zshenv
ln -s ".zsh/zshenv" "$HOME/.zshenv"

# VIM
echo
echo "Installing vim... ~/.vim[,rc]"
bkp .vim
ln -s "$vhome" "$HOME/.vim"

bkp .vimrc
ln -s "$HOME/.vim/vimrc" "$HOME/.vimrc"

(cd ~/.vim/bundle/YouCompleteMe && ./install.sh)

# TMUX
echo
echo "Installing tmux... ~/.tmux[,.conf]"
bkp .tmux
ln -s "$thome" "$HOME/.tmux"

bkp .tmux.conf
ln -s ".tmux/tmux.conf" "$HOME/.tmux.conf"

echo
echo "Installing mc... ~/.mc"
bkp .mc
mkdir -p "$HOME/.config"
ln -s "$dothome/mc" "$HOME/.config/mc"

# Git
echo
echo "Configuring git..."
git config --global merge.tool vimdiff
git config --global core.excludesfile "$dothome/gitignore-global"

# Others
echo
echo "Copying fonts"
cp -R $dothome'/fonts' "/Library/Fonts"

echo
echo "Done!"
