
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
#[[ $- == *i* ]] && . ~/.git-prompt.sh

NM="\[\033[0;38m\]" # means no background and white lines
HI="\[\033[01;37m\]" # change this for letter colors
HII="\[\033[38;5;214m\]" # change this for letter colors
SI="\[\033[38;5;34m\]" # this is for the current directory
IN="\[\033[0m\]"

export PS1="$NM[ $HI\u $HII\h $SI\w$NM ] $IN"
#export PS1='\u@\h:\w$ '
export HISTSIZE=1000
export HISTCONTROL=ignoreboth
export HISTIGNORE=l:ls:ps:cd

test -f ~/.bash_aliases && . ~/.bash_aliases
test -f /usr/local/etc/profile.d/bash_completion.sh && . /usr/local/etc/profile.d/bash_completion.sh

shopt -s histappend
shopt -s autocd             # change to named directory
shopt -s cdable_vars        # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell            # autocorrects cd misspellings
shopt -s checkwinsize       # update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist            # save multi-line commands in history as single line
shopt -s dotglob            # include dotfiles in pathname expansion

test `uname` == Linux && {
	# part of kernel patch that improves interactive performance
	if [ "$PS1" ] ; then
		mkdir -p -m 0700 /dev/cgroup/cpu/user/$$ >/dev/null 2>&1
		echo $$ >/dev/cgroup/cpu/user/$$/tasks
		echo "1" >/dev/cgroup/cpu/user/$$/notify_on_release
	fi

	alias vi=gvim
	export EDITOR=gvim
	export BROWSER=chromium
	export PAGER=less
	export PATH=$PATH:/opt/bin:~/bin
	export NODE_PATH=/usr/local/lib/jsctags:$NODE_PATH
}

test `uname` == Darwin && {
	alias vi='mvim -p'
	export EDITOR='mvim -p'
	export PAGER=vimpager
	export PATH=/usr/local/bin:`echo $PATH | sed 's#:/usr/local/bin##g'`:~/bin
	export NODE_PATH=/usr/local/lib/node
}

test -f ~/.dircolors && eval `dircolors -b ~/.dircolors`
export TERM=xterm-256color
# for tmux: export 256color
[ -n "$TMUX" ] && export TERM=screen-256color
export CATALINA_HOME=~/src/tomcat7

# Autocomplete for 'g' and 'h' as well
complete -o default -o nospace -F _git g
complete -o default -o nospace -F _hg h

