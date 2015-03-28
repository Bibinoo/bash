# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

#===============================================================
#
# PERSONAL $HOME/.bashrc FILE for bash-2.05a (or later)
#
# Last modified: Mon Jan 17 
#
# This file is read (normally) by interactive shells only.
# Here is the place to define your aliases, functions and
# other interactive features like your prompt.
#
# This file was designed (originally) for Solaris but based 
# on Redhat's default .bashrc file
# --> Modified for Linux.
# The majority of the code you'll find here is based on code found
# on Usenet (or internet).
# This bashrc file is a bit overcrowded - remember it is just
# just an example. Tailor it to your needs
# --> Tailored to be operable on the NLSU2 with Unslung 1.x 
#     onwards. It has been cut down somewhat from the original
#     sample found at:
#     http://www.tldp.org/LDP/abs/html/sample-bashrc.html#BASHRC
#
#===============================================================

#-----------------------------------
# Source global definitions (if any)
#-----------------------------------

if [ -f /opt/etc/bashrc ]; then
        . /opt/etc/bashrc   # --> Read /opt/etc/bashrc, if present.
fi


#-----------------------
# Greeting, motd etc...
#-----------------------

# Define some colors first (defined in /opt/etc/bashrc):

# Looks best on a black background.....
echo -e "${CYAN}BASH ${RED}${BASH_VERSION%.*}$NC"
echo -e "\n${RED}Machine information:$NC " ; uname -a
echo -e "\n${RED}Users logged on:$NC " ; w -h
echo -e "\n${RED}Current date :$NC " ; date
echo -e "\n${RED}Machine stats :$NC " ; uptime
echo -e "\n${RED}Memory stats :$NC " ; free my_ip 2>&- ;
echo -e "\n${RED}Free Disk Space :$NC" ; df
echo

# function to run upon exit of shell
function _exit()
{
    echo -e "${NC}Bye Bye${NC}"
}
trap _exit EXIT

#---------------
# Shell Prompt
#---------------

#  --> Replace instances of \W with \w in prompt functions below
#  --> to get display of full path name.

function fastprompt()
{
    unset PROMPT_COMMAND
    case $TERM in
        *term | screen* | putty* | rxvt | linux )
            PS1="\\[${red}"'${debian_chroot:+($debian_chroot)}\u'${green}'@'${cyan}'\h'${red}':'"${yellow}"'\w\$ '"${NC}" ;;
        *)
            PS1="//\h\w# " ;;
    esac
}

fastprompt
#----------------------------------
# You may uncomment the following lines if you want `ls' to be colorized:
#----------------------------------
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

#-----------------------------------
# Set default mask for files
#-----------------------------------
umask 022

#-----------------------------------
# File & strings related functions:
#-----------------------------------

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }
# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'$1'*' -exec "${2:-file}" {}\;  ; }

function ii()   # get current host related info
{
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
#    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Memory stats :$NC " ; free my_ip 2>&- ;
    echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
    echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:-"Not connected"}
    echo -e "\n${RED}Free Disk Space :$NC" ; df
    echo
}

#-----------------------------------
# Check Functions
#-----------------------------------

check_command_exists () {
    type "$1" &> /dev/null ;
}

#-----------------------------------
# Git Configuration 
#-----------------------------------

if check_command_exists git ; then 

    echo "git is installed then setting it"

    if [ -f ~/.gitrc ]; then
	. ~/.gitrc
    esle
	echo "git configuration not present, aborting ..."
    fi
else
    echo "git is not installed then not setting it"
fi

#-----------------------------------
# Setfacl Configuration
#-----------------------------------

if check_command_exists setfacl ; then 

    echo "$1 is installed then setting it"

    if [ -f ~/permissions.acl ]; then
	cd ~
	setfacl --restore=permissions.acl 
    fi
else
    echo "$1 is not installed then not setting it"
fi
