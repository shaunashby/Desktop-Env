#!/bin/zsh -x
#____________________________________________________________________ 
# File: zshenv
#____________________________________________________________________ 
#  
# Author: Shaun Ashby <Shaun.Ashby@gmail.com>
# Update: 2005-09-03 18:15:48+0200
# Revision: $Id$ 
#
# Copyright: 2005 (C) Shaun Ashby
#
#--------------------------------------------------------------------

PATH=$HOME/bin:$HOME/scripts:/opt/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin; export PATH

# Common environment:
EDITOR=emacs; export EDITOR
PAGER=less; export PAGER
TERM=xterm-color; export TERM

if [[ "x$EMACS" != "x" ]]; then
TERM=dumb; export TERM
fi

# ZSH stuff:
LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.sh=01;32:*.csh=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:"; export LS_COLORS

ZLS_COLORS=$LS_COLORS
LOGCHECK=60
ENABLE_ZSH_WATCH=0

if [[ $ENABLE_ZSH_WATCH -eq 1 ]]; then
 WATCHFMT="[%B%t%b] %B%n%b has %a %B%l%b from %B%M%b"
 watch=(notme)
fi

# Path to ZSH functions:
fpath=($HOME/.env/zshfunctions $fpath)

# Interface to perlbrew environment:
export PERLBREW_ROOT=/opt/perl5/perlbrew
export PERLBREW_HOME=$HOME/.perlbrew

. $PERLBREW_ROOT/etc/bashrc

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
