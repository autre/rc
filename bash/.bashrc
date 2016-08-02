
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

NM="\[\033[0;37m\]" # means no background and white lines
AMI="\[\033[01;34m\]" # change this for letter colors
MACH="\[\033[01;31m\]" # change this for letter colors
CD="\[\033[38;5;34m\]" # this is for the current directory
RESET="\[\033[0m\]"

export PS1="\[\033[G\]$AMI\u$NM/$MACH\h $CD\w$NM λ $RESET"
export HISTFILESIZE=10000 # Record last 10,000 commands
export HISTSIZE=10000 # Record last 10,000 commands per session
export HISTCONTROL=ignoreboth
export HISTIGNORE=l:ls:ps:cd

shopt -s histappend
shopt -s autocd # change to named directory
shopt -s cdable_vars # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell # autocorrects cd misspellings
shopt -s checkwinsize # update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob # include dotfiles in pathname expansion

export PAGER=less
export BROWSER=firefox
export EDITOR=gvim

unset MAILCHECK

test -f ~/.bash_aliases && . ~/.bash_aliases
test -n "$TMUX" && export TERM=screen-256color # for tmux: export 256color
test -f ~/.current.dircolors && eval `dircolors ~/.current.dircolors`
test -f /usr/share/nvm/init-nvm.sh && . /usr/share/nvm/init-nvm.sh
rm -fr ~/Desktop ~/Downloads
test -f /usr/share/bash-completion/completions/git && . /usr/share/bash-completion/completions/git
complete -o default -o nospace -F _git g
