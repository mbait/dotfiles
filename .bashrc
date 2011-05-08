# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
AXIOM='/home/mbait/src/fricas/ax-build/target/i686-pc-linux/'
export AXIOM
PATH=${AXIOM}/bin:${PATH}
export PATH

# original PS1
# export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
export PS1='\[\033[01;32m\]\[\u@`uname -n`\[\033[01;34m\]:\w (`jobs | wc -l`)\]\n>\[\033[00m\] '
