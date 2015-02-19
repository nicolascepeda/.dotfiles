#!/bin/bash

git_identities=( user1 user2 )

git_ident_user1_name="Awesome User"
git_ident_user1_email="awesome@user.com"

git_ident_user2_name="Another Awesome User"
git_ident_user2_email="another.awesome@user.com"

git_dir="$( pwd )/.git"
no_auto_ident="${git_dir}/no-auto-ident"

##
# Check the current repo matches one of the entries in $git_identities. 
#
# @return echos the matching identity with exit 0, otherwise exit 1
#
gitauthor(){
  if [ -d "$git_dir" ]; then
     if [ -f "$no_auto_ident" ]; then
        exit 0
     fi

     for ident in ${git_identities[@]}; do 
       out=$(cat "$git_dir/config" | grep $ident )
       if [ ! -z $out ]; then
         echo $ident
         exit 0
       fi
     done
     exit 0
  fi
  exit 1
}

##
# Echo GIT_{AUTHOR,COMMITER}_{NAME,EMAIL} given identity.
#
gitident() {
  ident=$( gitauthor )
  if [ ! -z "$ident" ]; then
    gitu="git_ident_${ident}_name"
    gite="git_ident_${ident}_email"
    echo "GIT_AUTHOR_NAME=\"${!gitu}\" GIT_AUTHOR_EMAIL=\"${!gite}\" GIT_COMMITTER_NAME=\"${!gitu}\" GIT_COMMITER_EMAIL=\"${!gite}\"" 
  fi
}

gitident 
