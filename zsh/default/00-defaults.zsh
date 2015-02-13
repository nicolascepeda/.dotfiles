#!/bin/zsh

autoload -U vagrant-exec

autoload -Uz zutil
zstyle ':completion:*' completer _expand _complete _ignored _approximate

autoload -Uz compinit
compinit

export HISTSIZE=1000
export SAVEHIST=1000 # only saved after logout
export HISTFILE=$HOME/.zshhist
setopt \
    inc_append_history \
    hist_save_no_dups \
    hist_reduce_blanks \
    hist_ignore_all_dups

# Auto cd -> cdpath, see Darwin.zshenv or other platform specific
# configuration
setopt \
    autocd \
    extendedglob \
    notify \
    extendedhistory
    #completealiases
    #nomatch
