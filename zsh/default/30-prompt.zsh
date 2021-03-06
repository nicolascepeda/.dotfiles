#!/bin/zsh

autoload -U promptinit
promptinit

# colorized stderr
# http://en.gentoo-wiki.com/wiki/Zsh
# TODO: there seme to be an error in coloring...
#exec 2>>(while read line; do
#  print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done &)

##>> Prompt
# credits:
# - http://aperiodic.net/phil/prompt/
#     very thorough explanation of most of the things happening in
#     precmd, preexec, and setprompt. Thanks for putting that page
#     online.
# - Merci gäu dän


if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
    st=$($git status 2>/dev/null | tail -n 1)
    # Dirty hack to circumvent a change that broke the dirty flag in
    # a recent git version (I don't know exactly which one).
    st2=$($git status 2>/dev/null | tail -n 2)
    if [[ ( $st == "" ) && ( $st2 == "" ) ]]
    then
        echo ""
    else
        if [[ "$st" =~ ^nothing ]]
        then
            echo "%{$reset_color%} on %{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%}"
        else
            echo "%{$reset_color%} on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
        fi
    fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}"
}

# Compute the length of git status information shown in prompt
git_prompt_size () {
 local zero='%([BSUbfksu]|([FB]|){*})' # removes escape characters
 promptgit="$(git_dirty)"
 ${#${(S%%)promptgit//$~zero/}}
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

git_need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo ""
  else
    echo " %{$fg_bold[red]%}!%{$reset_color%}"
  fi
}

# calculate cmd extends
function precmd {
 local TERMWIDTH
 (( TERMWIDTH = ${COLUMNS} - 1 ))

 # truncate the path if it's too long.
 PR_FILLBAR=""
 PR_PWDLEN=""

 # compute size of prompt and pwd

 local promptsize=${#${(%):-%n@%m }}
 local pwdsize=${#${(%):-%~}}

 local zero='%([BSUbfksu]|([FB]|){*})' # removes escape characters
 local promptgit="$(git_dirty)$(git_need_push)"
 local promptgitsize=${#${(S%%)promptgit//$~zero/}}

  if [[ "$promptsize + $pwdsize + $promptgitsize" -gt $TERMWIDTH ]]; then
     ((PR_PWDLEN=$TERMWIDTH - $promptsize))
 else
     PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize + $promptgitsize)))..${PR_HBAR}.)}"
 fi

 # print a 'bell' character:
 # In combination with 'URxvt.urgentOnBell: true' in your ~/.Xresources,
 # this will set an X11 urgent flag on the window when the prompt gets
 # redrawn. Handy to get informed about longrunning commands
 # finishishing in the foreground in not currently visible windows.
 print -n '\a'
}

# preexec is executed just after pressing enter.
# it's used to set the window title to just the command used
# preexec () {
#   local CMD=${1[(wr)^(*=*|sudo|-*)]}
#   echo -ne "\ek$CMD\e\\"
# }

# called once to initialize things.
setprompt () {
 # need this so the prompt will work.
 setopt prompt_subst

  # see if we can use extended characters to look nicer.
 typeset -A altchar
 set -A altchar ${(s..)terminfo[acsc]}
 PR_SET_CHARSET="%{$terminfo[enacs]%}"
 PR_SHIFT_IN="%{$terminfo[smacs]%}"
 PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
 PR_HBAR=${altchar[q]:--}
 PR_ULCORNER=${altchar[l]:--}
 PR_LLCORNER=${altchar[m]:--}
 PR_LRCORNER=${altchar[j]:--}
 PR_URCORNER=${altchar[k]:--}

 # left prompt
 PROMPT='$PR_SET_CHARSET\
%(!.%SROOT%s.%n)$PRMT_CLR@$PR_NO_COLOUR$PR_LIGHT_GREEN%m\
$PR_NO_COLOUR %$PR_PWDLEN<...<$PRMT_CLR_LGHT${(%):-%~}$(git_dirty)$(git_need_push)\
%<<$PR_NO_COLOUR $PR_SHIFT_IN${(e)PR_FILLBAR}$PR_SHIFT_OUT
$PR_NO_COLOUR%! %(!.$PR_RED.$PR_WHITE)%#$PR_NO_COLOUR '

 # right prompt
 RPROMPT=''

 # continuation prompt
 PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}

typeset -U path

setprompt
