# setup vim: set syntax=sh :

alias ls='ls -F --color=auto'
alias l='ls -lhtr'
alias la='l -A'
alias ..='cd ..'
alias ...='cd ../..'
alias diff='colordiff -uw'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -h'
alias du='du -h'
alias cp='cp --strip-trailing-slashes'
alias mv='mv --strip-trailing-slashes'
alias p=less

test `uname` == Darwin && {
	test -f $(brew --prefix)/etc/bash_completion && . $(brew --prefix)/etc/bash_completion
	alias tmux="TERM=screen-256color-bce tmux"
}

test -f /usr/share/bash-completion/completions/git && . /usr/share/bash-completion/completions/git
complete -o default -o nospace -F _git g

alias g=git
alias gs='git status'
alias gd='git diff'
