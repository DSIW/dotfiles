#!/bin/env sh
# fork of https://github.com/spf13/spf13-vim/blob/3.0/bootstrap.sh

endpath="$HOME/.vim"

warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

echo -e "thanks for installing vim\n"

# Backup existing .vim stuff
echo -e "backing up current vim config\n"
today=`date +%Y%m%d`
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc; do [ -e $i ] && mv $i $i.$today; done


echo -e "cloning vim-config\n"
git clone --recursive git://github.com/DSIW/vim.git $endpath
mkdir -p $endpath/bundle
ln -s $endpath/.vimrc $HOME/.vimrc
ln -s $endpath/.vim $HOME/.vim

echo "Installing Vundle"
git clone http://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle

echo "installing plugins using Vundle"
vim +BundleInstall! +BundleClean +q
