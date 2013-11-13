
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

NM="\[\033[0;38m\]" # means no background and white lines
HI="\[\033[01;37m\]" # change this for letter colors
HII="\[\033[01;31m\]" # change this for letter colors
SI="\[\033[38;5;34m\]" # this is for the current directory
IN="\[\033[0m\]"

export PS1="\[\033[G\]$NM[ $HI\u $HII\h $SI\w$NM ] $IN"
#export PS1='\u@\h:\w$ '
export HISTFILESIZE=10000 # Record last 10,000 commands
export HISTSIZE=10000 # Record last 10,000 commands per session
export HISTCONTROL=ignoreboth
export HISTIGNORE=l:ls:ps:cd

test -f ~/.bash_aliases && . ~/.bash_aliases
test -f /usr/local/etc/profile.d/bash_completion.sh && . /usr/local/etc/profile.d/bash_completion.sh

shopt -s histappend
shopt -s autocd # change to named directory
shopt -s cdable_vars # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell # autocorrects cd misspellings
shopt -s checkwinsize # update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob # include dotfiles in pathname expansion

test `uname` == Linux && {
	alias vi=gvim
	export EDITOR=gvim
	export BROWSER=firefox
	export TERMINAL=gnome-terminal
	export PAGER=less
	export PATH=$PATH:/opt/bin:~/bin
}

test `uname` == Darwin && {
	alias vi='mvim -p'
	export EDITOR='mvim -p'
	export PAGER=less
	export PATH=/usr/local/bin:`echo $PATH | sed 's#:/usr/local/bin##g'`:~/bin
	export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.7.0_21.jdk/Contents/Home'
	export TERM=xterm-256color
}

test -f ~/.dircolors && eval `dircolors -b ~/.dircolors`
export GREP_OPTIONS='--color=auto'
[ -n "$TMUX" ] && export TERM=screen-256color # for tmux: export 256color

# Autocomplete for 'g' and 'h' as well
complete -o default -o nospace -F _git g
complete -o default -o nospace -F _hg h

test -f ~/.maven-completion.sh && . ~/.maven-completion.sh
test -f /usr/share/git/completion/git-completion.bash && . /usr/share/git/completion/git-completion.bash

# https://gist.github.com/590895
function git_current_branch() {
  git symbolic-ref HEAD 2>/dev/null | sed -e 's/refs\/heads\///'
}
