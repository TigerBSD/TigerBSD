# Copyright (c) 2015, 2016 Erik Nordstrøm <erik@nordstroem.no>

# If not running interactively, don't do anything
#[ -z "$PS1" ] && exit 1

[[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]] && \
	source /usr/local/share/bash-completion/bash_completion.sh

os_name="$( uname -s -r )"
hn="$( hostname -s )"
wtitle="$hn ($os_name) \w\a"
pscol="\[\e[1;33m\]\u\[\e[0m\]@\[\e[1;31m\]$hn\[\e[0m\]:\w (\[\e[1;34m\]\${PROFILE}\[\e[0m\]) \[\e[1;32m\]\$\[\e[0m\] "
ps1_tpl="\[\e]0;$wtitle\]$pscol"

# Switch "profile"
swpr()
{
  success=1
  name='Erik Nordstrøm'
  case "$1" in
    nordstroem.no)
      email="erik@$1"
      ;;
    ntnu.no)
      email="eriknstr@$1"
      ;;
    hig.no)
      email="erik.nordstrom@$1"
      ;;
    ict-infer.no \
    | LoBSD.org \
    | whatis.re)
      email="erikn@$1"
      ;;
    *)
      echo "Unknown domain \`$1'. Identity unchanged."
      success=0
      ;;
  esac
  if [[ "$success" = "1" ]] ; then
    export GIT_AUTHOR_NAME="$name"
    export GIT_AUTHOR_EMAIL="$email"
    export GIT_COMMITTER_NAME="$name"
    export GIT_COMMITTER_EMAIL="$email"
    export EMAIL="$email"
    export PS1=$( echo "$ps1_tpl" | sed "s/\${PROFILE}/$1/g" )
  else
    return 1
  fi
}

_swpr()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "nordstroem.no ntnu.no ict-infer.no LoBSD.org whatis.re hig.no" -- "$cur") )
}
 
complete -F _swpr swpr

[[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]] && \
        source /usr/local/share/bash-completion/bash_completion.sh

alias u='doas pkg update && doas pkg upgrade'
alias s='doas pkg search'
alias i='doas pkg install'

alias le="git shortlog -s -e"
alias st="git status"
alias aa="git add ."
alias di="git diff --cached"
alias dp="git diff"
alias pu="git push"
alias cm="git commit -m"
alias wh="git rev-parse --short HEAD"
alias la="git log -n1"

# Modification stats based on git log of a file
ms()
{
  git log --date=format:%s --pretty=format:%ad $1 \
  | sed 'p;1d;$d' | paste -d- - - | bc \
  | Rscript -e 'print(summary(scan("stdin")));'
}

ll()
{
  ls -al $@ | rev | sort | rev
}

alias sl='screen -ls'
alias sr='screen -dUR'

alias non="swpr nordstroem.no"
alias bsd='swpr LoBSD.org && cd ~/src/github.com/LoBSD/LoBSD/'

alias rp='ping $( echo $SSH_CLIENT | cut -d" " -f1 )'

alias vim=nvim

alias HEAD='curl -I'

export PATH=~/bin:$PATH:/usr/local/lib/qt5/bin
export TZ=Europe/Oslo
export EDITOR=nvim
export PAGER=less

swpr nordstroem.no

alias ls='ls -GF'
alias open='xdg-open'

examples ()
{
  man $1 | less +/^EXAMPLES
}

export PROMPT_DIRTRIM=2

if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l | grep "The agent has no identities" && ssh-add

source $HOME/.cargo/env
