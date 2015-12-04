#
# ~/.bash_profile
#

test -f ~/.bashrc && . ~/.bashrc
test -f ~/.dircolors && eval `dircolors -b ~/.dircolors`

test `uname` == Darwin && {
	export SHELL=/usr/local/bin/bash
}
