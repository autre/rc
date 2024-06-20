
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
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE=l:ls:ps:cd

shopt -s histappend
shopt -s autocd # change to named directory
shopt -s cdable_vars # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell # autocorrects cd misspellings
shopt -s checkwinsize # update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob # include dotfiles in pathname expansion
# shopt -s direxpand # expand vars, avoiding backslash

export PAGER=less
export BROWSER=firefox
export EDITOR=vim
export PATH=$HOME/bin:$PATH
export TERM=xterm-256color # for a tmux -2 session (also for screen)
export LC_TIME=el_GR.UTF-8

unset MAILCHECK

test -f ~/.bash_aliases && . ~/.bash_aliases
test -f ~/.current.dircolors && eval `dircolors ~/.current.dircolors`
test -f ~/.maven-completion.sh && . ~/.maven-completion.sh
test -f /usr/share/bash-completion/completions/git && . /usr/share/bash-completion/completions/git
complete -o default -o nospace -F _git g

__git_complete g __git_main

export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108 --color info:108,prompt:109,spinner:108,pointer:168,marker:168'

export SDKMAN_DIR="/home/vassilis/.sdkman"
[[ -s "/home/vassilis/.sdkman/bin/sdkman-init.sh" ]] && source "/home/vassilis/.sdkman/bin/sdkman-init.sh"

export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
