#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
test -f ~/.dircolors && eval `dircolors -b ~/.dircolors`

test `uname` == Darwin && {
	export SHELL=/usr/local/bin/bash
}

# The next line updates PATH for the Google Cloud SDK.
source '/Users/bill/.rc/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/Users/bill/.rc/google-cloud-sdk/completion.bash.inc'
