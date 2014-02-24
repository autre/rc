# setup vim: set syntax=sh :

alias ls='ls -F --color=auto'
alias l='ls -lhtr'
alias la='l -A'
alias ..='cd ..'
alias ...='cd ../..'
alias less='less -R'
alias p=less
alias diff='colordiff -uw'
alias indent='indent -kr -i8'
alias jtags='ctags -R --language-force=java'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias xargs='xargs -P 4'
alias unrar='unrar x'
alias df='df -h'
alias du='du -h'
alias cp='cp --strip-trailing-slashes'
alias mv='mv --strip-trailing-slashes'
alias gh=hg
alias gs='git status'
alias gd='git diff'
alias g='git'
alias h='hg'
alias hs='hg st'
alias hd='hg diff'
alias openports='netstat --all --numeric --programs --inet --inet6'

# https://gist.github.com/590895
alias gpthis='git push origin HEAD:$(git_current_branch)'
alias grb='git rebase -p'
alias gup='git fetch origin && grb origin/$(git_current_branch)'
alias gm='git merge --no-ff'

