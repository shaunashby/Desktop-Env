#!/bin/zsh
#____________________________________________________________________ 
# File: zlogin
#____________________________________________________________________ 
#  
# Author: Shaun Ashby <Shaun.Ashby@gmail.com>
# Update: 2005-09-01 00:07:34+0200
# Revision: $Id$ 
#
# Copyright: 2005 (C) Shaun Ashby
#
#--------------------------------------------------------------------

# This script is run only when zsh is a login shell (e.g via xterm -ls):
echo "Welcome to `hostname -s` on `date`"
echo "------ "
if [[ "$(uname)" != "Darwin" ]]; then
    # Start ssh-agent if there is not one running already:
    if [[ $(ps -u$USER|grep -c ssh-agent) -eq 0 ]]; then
        echo "-> Starting SSH agent for user $USER"
        eval $(ssh-agent -s)
    fi
fi
echo ""