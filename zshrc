#!/bin/zsh
#____________________________________________________________________ 
# File: zshrc
#____________________________________________________________________ 
#  
# Author: Shaun Ashby <Shaun.Ashby@gmail.com>
# Update: 2005-08-31 23:18:41+0200
# Revision: $Id$ 
#
# Copyright: 2005 (C) Shaun Ashby
#
#--------------------------------------------------------------------

# Set shell options:
setopt ignoreeof
setopt nobeep
setopt nocheckjobs             # Don't warn about bg processes when exiting
setopt nohup                   # Don't kill them, either
setopt HIST_IGNORE_ALL_DUPS    # Ignores duplications
setopt always_to_end	       # Move to cursor to the end after completion
setopt extended_glob	       # In order to use #, ~ and ^ for filename generation

# Arrays for completion system:
hosts=(git jenkins foreman-01 puppetmaster-01 mntmgt pcnas.ashby.ch qnas1.ashby.ch websrv01.ashby.ch www.ashby.ch github.com)
accounts=(sashby shaun ashby root frontrow shaunashby)

# Activate the completion system:
autoload -Uz compinit
compinit

# Completion options:
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.env/zshfunctions/cache
# completion colours:
zstyle ':completion:*' list-colors "$LS_COLORS"
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' completer _complete _prefix _ignored _complete:-extended
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:*:approximate-one:*'  max-errors 1
zstyle ':completion:*:approximate-four:*' max-errors 4
# e.g. f-1.j<TAB> would complete to foo-123.jpeg:
zstyle ':completion:*:complete-extended:*' matcher 'r:|[.,_-]=* r:|=*'
zstyle ':completion:*:processes' command 'ps -aU $USER'
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*' hosts $hosts
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
zstyle ':completion:*:my-accounts' users-hosts $accounts
zstyle ':completion:*' expand 'no'
# Handle duplicated slashes, e.g. a/b//c
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename "$HOME/.zshrc"

hst=`echo $HOST | tr '[a-z]' '[A-Z]'`
TERMSTRING="xterm@$hst"

case $TERM in
    xterm*|vt*)
	precmd() 
	{
	    print -Pn "\e]0; $TERMSTRING: %~ \a"
	}
	# Change the prompt at the same time:
	PS1="%B[ %m ] >%b "
	
	set_colour_vars()
	{
	    NORM="\033[0m"; export NORM
	    BOLD="\033[1m"; export BOLD
	    REVERSE="\033[7m"; export REVERSE
	    BLACK="\033[0;30m"; export BLACK
	    DARKGREEN="\033[0;32m"; export DARKGREEN
	    BROWN="\033[0;33m"; export BROWN
	    DARKBLUE="\033[0;34m"; export DARKBLUE
	    DARKMAGENTA="\033[0;35m"; export DARKMAGENTA
	    DARKCYAN="\033[0;36m"; export DARKCYAN
	    DARKGRAY="\033[0;30;1m"; export DARKGRAY
	    GRAY="\033[0;37m"; export GRAY
	    RED="\033[0;31;1m"; export RED
	    GREEN="\033[0;32;1m"; export GREEN
	    YELLOW="\033[0;33;1m"; export YELLOW
	    BLUE="\033[0;34;1m"; export BLUE
	    MAGENTA="\033[0;35;1m"; export MAGENTA
	    CYAN="\033[0;36;1m"; export CYAN
	    WHITE="\033[0;37;1m"; export WHITE	
	}
	;;
    dumb)
	# Handle use of zsh in emacs shell-mode:
	[[ $EMACS = t ]] && unsetopt zle
	PS1="%S[ emacs@%m ]%s %B>%b "
	;;
    *)
	PS1="$USER > "
	;;
esac

# Aliases:
alias 'll=ls -l -G'
alias 'pa=ps -aU $USER | more'
alias 'l=ll'
alias 'lll=ll'
alias 'dir=ll'
alias 'LL=ll'
alias 'h=history'
alias 'm=more'
alias 'morel=more'
alias 'rm=rm -i'

# Make sure that "which" is the shell function:
alias which >&/dev/null && unalias which

# Other ZSH parameters:
HISTSIZE=10000
HISTFILE=$HOME/.env/.zsh-history
SAVEHIST=10000
DIRSTACKSIZE=20

# No coredumps, thanks:
ulimit -c 0
