#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -e /Users/bill/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/bill/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

test -f ~/.dircolors && eval `dircolors -b ~/.dircolors`

test `uname` == Darwin && {
	export SHELL=~/.nix-profile/bin/bash
}
