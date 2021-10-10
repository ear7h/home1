
if [[ `uname` == 'Darwin' ]]; then
	alias ls='ls -G'
	alias l='ls -lGh'
	alias la='ls -Ga'

	alias grep='grep --colour=auto'

	# alias diff='colordiff'
else
	alias ls='ls --colo=auto'
	alias l='ls --color=auto -lh'
	alias la='ls --colo=auto -a'

	alias grep='grep --color=auto'

	alias diff='diff --color'
fi

alias hm='home-manager'

# curl download

alias dl='curl -LO'

# easy cd

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias shutdown='sudo shutdown'
