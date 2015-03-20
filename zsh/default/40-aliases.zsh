#!/bin/zsh

###>> Aliases
alias e='$EDITOR'

alias f='grep -r'

# Git related aliases
# See http://nuclearsquid.com/writings/git-tricks-tips-workflows/
alias g='git'
alias gs='g status'
alias ga='g add --all'
alias gc='g commit -a -m'
alias gp='g push'
alias gpo='g push origin'
alias gu='g pull'
alias gb='g branch'
alias gt='g tag'
alias gch='g checkout'
alias gchb='g checkout -B'
alias gm='g merge'
alias gsa='g submodule add'

alias l='ls -lh'
alias ll='ls -lha'

alias mk='mkdir -p'
alias mc='MC_SKIN="$HOME/.config/mc/nicedark.ini" mc'

alias p='print -l'
alias pp='p $path'
alias psa="ps aux | grep "

alias sudo='sudo '
# Assume ~/.ssh/config has a Host definition
# setting credentials & co
alias ssht='ssh -f -N '

# tmux
alias t='tmux'
alias ts='t new -s '
alias tl='t ls'
alias ta='t attach -t '
alias td='t detach'

alias v='vagrant'
alias vx='vagrant-exec'

alias y='pbcopy <'

function vim_pathogen() {
    echo "Downloading to '$DOTFILES_VIM/bundle'"
    (cd $DOTFILES_VIM/bundle && git clone $1)
}
alias vpat='vim_pathogen'
