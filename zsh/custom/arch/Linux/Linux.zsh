#!/bin/sh

###>> SSH
# Arch does (as do other distributions) not export ssh-agent
# environment variables (SSH_AUTH_SOCK, SSH_AGENT_PID, ...) by
# default. Also using ssh-agent spawns a new ssh-agent process with
# every login session. To circumvent this problem install keychain,
# which is available in the official arch repo.

# see https://wiki.archlinux.org/index.php/SSH_Keys#SSH_agents
#eval $(ssh-agent) # this would spawn a nef ssh-agent with every login
eval $(keychain --eval --agents ssh -Q --quiet)

if [[ -d $HOME/.ssh/keys_auto ]]; then
    # Delete & add keys
    ssh-add -D 1&> /dev/null
    find "$HOME/.ssh/keys_auto" | grep keys_auto/ | xargs ssh-add 1&> /dev/null
fi

# This makes cd'ing to frequently used dirs a swift!
# Credits: http://robots.thoughtbot.com/cding-to-frequently-used-directories-in-zsh
cdpath=($HOME /vagrant)

# See colors in ~/.zsh/zshrc
PRMT_CLR=$PR_BLUE

alias ls='ls --color'
