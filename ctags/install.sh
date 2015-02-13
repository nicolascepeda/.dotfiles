#!/bin/sh

dothome="$HOME/.dotfiles"
ctagsh="$dothome/ctags"
ctagsc="$ctagsh/ctags.config.gen"

FS="$ctagsh/langs/*"
cat defaults > $ctagsc

# Generate ctags config
for f in $FS
do 
    echo >> $ctagsc
    cat $f >> $ctagsc
done

# Symlink into home
rm "$HOME/.ctags" &> /dev/null
ln -s "$ctagsc" "$HOME/.ctags" 
