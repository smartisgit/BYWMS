#-------------------------------------------------------------------------------
#
# SOURCE FILE: .kshrc
#
# DESCRIPTION: LES environment's ksh options.
#
# NOTE(S): This script should *not* be edited.
#          Any customizations should be made in the ".kshrc.local" script 
#          instead, which this script calls.
#
#-------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Setup ksh options.
# ------------------------------------------------------------------------------

set -o vi               #  Use the built-in vi editor.
set -o nolog            #  Don't store functions in history file.
set -o trackall         #  Track all commands.

# ------------------------------------------------------------------------------
# Setup ksh aliases.
# ------------------------------------------------------------------------------

alias rpset='. /usr/local/bin/rp.env'
alias rpstart='/usr/local/bin/rp start'
alias rpstop='/usr/local/bin/rp stop'
alias rpshow='/usr/local/bin/rp show'

alias cd..='cd ..'
alias md='mkdir'
alias rd='rmdir'
alias cls='clear'

function dir  {
	ls -alLF "$@"
}

alias ll='ls -l'
alias lt='ls -t'     
