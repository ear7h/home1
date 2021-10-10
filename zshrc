export LANG=en_US.UTF-8
export ZSH=$HOME/.zsh
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000

# source $HOME/.nix-profile/etc/profile.d/nix.sh


#
# profile
#

if [ -f $HOME/.profile ]; then
	source $HOME/.profile
fi

#
# auto completion
#

autoload -U compaudit compinit
compinit
# source $ZSH/completion.zsh
# source $ZSH/oh-my-zsh.sh

#
# prompt functions
#

username() {
	pad=''
	if [ `whoami` != 'julio' -a `whoami` != 'ear7h' ]; then
		echo -n $(whoami)
		pad=' '
	fi

	if [ `hostname` != 'julio-mbp.local' -a `hostname` != 'julio-thinks' ]; then
		echo -n '@'$(hostname)
		pad=' '
	fi

	echo -n $pad
}

git_prompt() {
	branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
	if [ $? -eq 0 ]; then

		echo $branch | grep -q '^master\|main$'
		if [[ $? -eq 0 ]]; then
			branch=''
		fi

		git_status=$(git status -s 2> /dev/null)

		echo $git_status | grep -q "^M"
		if [ $? -eq 0 ]; then
			staged="S"
		fi

		echo $git_status | grep -q "^.M"
		if [ $? -eq 0 ]; then
			mod="M"
		fi

		echo $git_status | grep -q "??"
		if [ $? -eq 0 ]; then
			new="?"
		fi

		echo $git_status | grep -q "^A"
		if [ $? -eq 0 ]; then
			add="+"
		fi

#		diff=$(git log --left-right --graph --cherry-pick --oneline \
#			$(git branch --format='%(upstream)...%(refname)'))

		diff=$(git diff --name-only HEAD @{u} 2> /dev/null)
		if [ ! -z $diff ]; then
			diff='≠'
		fi

#		recv=$(( $(echo diff | grep '^<' | wc -l) ))
#		if [ $recv -ne 0 ]; then
#			recv="⊻$recv"
#		else
#			recv=''
#		fi

#		send=$(( $(echo diff | grep '^>' | wc -l) ))
#		if [ $send -ne 0 ]; then
#			send="⊼$send"
#		else
#			send=''
#		fi

		echo -n ' ' $branch $staged$mod$new$add $diff $(gradient $(git_color))
	fi
}

git_color() {
	git_status=$(git status -s 2> /dev/null)
	if [ $? -ne 0 ]; then
		echo -n ""
	elif [ -z $git_status ]; then
		echo -n green
	else
		echo -n yellow
	fi
}


preexec_timer() {
	timer_var=$SECONDS
}

precmd_timer() {
	if [ $timer_var ]; then
		delta=$(( $SECONDS - $timer_var ))
		export CMD_TIME=$(printf '%02d:%02d' \
			$(( delta / 60 )) $(( delta % 60 )))
		unset timer_var
	else
		export CMD_TIME=''
	fi
}

preexec() {
	preexec_timer
}

precmd() {
	roll_die
	precmd_timer
}

gradient() {
	if [ -z $2 ]; then
		echo -n "%F{$1}%k░%f"
	else
		echo -n "%F{$1}%K{$2}░%f"
	fi
}

kf() {
	echo -n "%K{$1}%F{$2}$3%f"
}

concat() {
	for arg in $@;do
		echo -n $arg
	done
}

rand_ten() {
	if [ `command -v jot` ]; then
		jot -r 1 1 10
	else
		shuf -i 1-10 -n 1
	fi
}

roll_die() {
	arr=('⚀' '⚁' '⚂' '⚃' '⚄' '⚅' '💖' '🌞' '🌻' '🌆')
	RANDOM_DIE=${arr[$(rand_ten)]}
}

__=' '

set_prompt() {
	setopt prompt_subst

	PROMPT=$(concat \
		$(kf white black '$__ %T $__') \
		$(kf white black $(username)) ' ' \
		$(gradient white blue) ' ' $(kf blue black '%3~' ) ' ' \
		'$(gradient blue $(git_color))' \
			$(kf '$(git_color)' black '$(git_prompt)') \
		'%k' ' ☞  ')

	RPROMPT=$(concat \
		$(gradient black) $(kf black white '%(?.$RANDOM_DIE.%F{red}%?%f)') ' ' \
		$(gradient white black) $(kf white black  '${__} 𝜟$CMD_TIME') '%E')
}

set_prompt

#
# key binding
#

export KEYTIMEOUT=20

# bindkey -v
# bindkey -v jj vi-cmd-mode

bindkey '^[f' forward-word # [opt-RightArrow] - move forward one word
bindkey '^[b' backward-word # [opt-LeftArrow] - move backward one word

export EDITOR=vim

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey hh edit-command-line

# start typing + [Up-Arrow] - fuzzy find history forward
# start typing + [Down-Arrow] - fuzzy find history backward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B"  down-line-or-beginning-search
