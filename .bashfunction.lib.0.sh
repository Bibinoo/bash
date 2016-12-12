#!/bin/bash
#set -E
#set -x
set +u
set +e
#####################################################################
# Global Variables
#####################################################################
FUNCTION_TO_TEST="no"

PROFILE_FILE=".profile"
BASHRC_FILE=".bashrc"
BASHPROFILE_FILE=".bash_profile"
BASHLIBRARY_FILE=".bashfunction.lib.0.sh"

GIT_HOME_REPO="/home/git/home-repo"

CURRENT_BASHPROFILE=~/${BASHPROFILE_FILE}
NEWER_BASHPROFILE=${GIT_HOME_REPO}/${BASHPROFILE_FILE}

CURRENT_PROFILE=~/${PROFILE_FILE}
NEWER_PROFILE=${GIT_HOME_REPO}/${PROFILE_FILE}

CURRENT_BASHLIBRARY=~/${BASHLIBRARY_FILE}
NEWER_BASHLIBRARY=${GIT_HOME_REPO}/${BASHLIBRARY_FILE}

CURRENT_BASHRC=~/${BASHRC_FILE}
NEWER_BASHRC=${GIT_HOME_REPO}/${BASHRC_FILE}

#####################################################################
# Functions check (variables, directlories, files ...)
#####################################################################
function init_debug_enabled() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Initialize debug and log messages systems
    ##
    ## ARGUMENTS:
    ##   1: Debug enabled (yes/no)
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: 
    ##   99: 
    ##

    ## ----- main -----

    echo "Function to be developed"
} # init_debug_enabled()

function check_variable_defined() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Check if a variable is defined
    ##
    ## ARGUMENTS:
    ##   1: variable to check
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: if the variable is defined (set) and value's length > 0
    ##   99: if the variable is not defined
    ##

    ## ----- main -----

    if [[ "$#" -ne 1 ]]; then
	echo "Please define the variable"
        return 99
    fi
    # Tricky.  Since Bash option 'set -u' may be enabled, we cannot directly test if a variable
    # is defined with this construct: [ ! -z "$var" ].  Instead, we must use default value
    # substitution with this construct: [ ! -z "${var:-}" ].  Normally, a default value follows the
    # operator ':-', but here we leave it blank for empty (null) string.  Finally, we need to
    # substitute the text from $1 as 'var'.  This is not allowed directly in Bash with this
    # construct: [ ! -z "${$1:-}" ].  We need to use indirection with eval operator.
    # Example: $1="var"
    # Expansion for eval operator: "[ ! -z \${$1:-} ]" -> "[ ! -z \${var:-} ]"
    # Code  execute: [ ! -z ${var:-} ]
    eval "[ ! -z \${$1:-} ]"
    echo "Wow this is working, the parameter is set"
    return $?  # Pedantic

} # check_variable_defined()

function check_variable_has_value() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Check if a variable has a value
    ##
    ## ARGUMENTS:
    ##   1: variable to check
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: if the variable is defined (set) and value's length > 0
    ##   1: if the variable is not defined or > 0
    ##

    ## ----- main -----

    if check_variable_defined $1; then
	#if [[ -n ${!1} ]]; then
	if [[ -z "$1" ]]; then
	    echo "Variable is set"
	fi
    fi
    return 1
} # check_variable_has_value()

function check_command_exists() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Check if a command is existing
    ##
    ## ARGUMENTS:
    ##   1: command to check
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: if the command exists
    ##   1: if the command doesn't exists
    ##   99: if the argument(s) is/are null or not specified
    ##

    ## ----- main -----

    # If no arg or arg is nothing then return 99 as an exit code
    if [[ "$#" == 0 ]] || [[ -z "$1" ]]; then echo "Parameter #1 is null or not specified, aborting" && return 99;fi

    # Setup local variable within function
    local __arg1="$1"

    # Check if the command is existing
    type "${__arg1}" &> /dev/null
    if [[ "$?" -eq 0 ]]; then
        echo "Command ${__arg1} is existing"
        return 0
    else
        echo "Command ${__arg1} is not existing. Returning 1 and exiting the function"
        return 1
    fi
} # check_command_exists()

function check_dir_exists() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Check if a directory is existing
    ##
    ## ARGUMENTS:
    ##   1: directory to check
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: if the directory exists
    ##   1: if the directory doesn't exists
    ##   99: if the argument(s) is/are null or not specified
    ##

    ## ----- main -----

    # If no arg or arg is nothing then return 99 as an exit code
    if [[ "$#" == 0 ]] || [[ -z "$1" ]]; then echo "Parameter #1 is null or not specified, aborting" && return 99;fi

    # Setup local variable within function
    local __arg1="$1"
    	
    # Check if the dir and/or file is existing
    if [[ -d "${__arg1}" ]]; then
	echo "Directory ${__arg1} is existing"
	return 0
    else
	echo "Directory ${__arg1} is not existing. Returning 1 and exiting the function"
	return 1
    fi
} # check_dir_exists()

function check_file_exists() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Check if a file is existing
    ##
    ## ARGUMENTS:
    ##   1: file to check
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: if the file exists
    ##   1: if the file doesn't exists
    ##   99: if the argument(s) is/are null or not specified
    ##

    ## ----- main -----

    # If no arg or arg is nothing then return 99 as an exit code
    if [[ "$#" == 0 ]] || [[ -z "$1" ]]; then echo "Parameter #1 is null or not specified, aborting" && return 99;fi

    # Setup local variable within function
    local __arg1="$1"
    	
    # Check if the dir and/or file is existing
    if [[ -f "${__arg1}" ]]; then
    	echo "File ${__arg1} is existing"
    	return 0
    else
    	echo "File ${__arg1} is not existing. Returning 1 and exiting the function"
	return 1
    fi
} # check_file_exists()

function check_new_file_available() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Check if a new file is available
    ##
    ## ARGUMENTS:
    ##   1: current file to check
    ##   2: new file to check
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: if there is no new available file (false)
    ##   1: if there is a new available file (true)
    ##   2: if the argument(s) is/are null or not specified
    ##

    ## ----- main -----

    # If 2 arg are existing and not null

    if [[ "$#" == 2 ]] && [[ -n "$1" ]] && [[ -n "$2" ]]; then
	# Setup local variable within function
	local __arg1="$1"
	local __arg2="$2"
	
	if [[ "${__arg1}" -ot "${__arg2}" ]]; then
	    echo "${__arg1} is older than ${__arg2}"
	    return 1 # True
	else
	    echo "There is no new available file for ${__arg1}"
	    return 0 # False
	fi
    else
	echo "Parameter #1 or/and #2 is null or not specified, aborting"
	return 2
    fi
} # check_new_file_available()

#####################################################################
#
# Others check (system update, file update ...)
#
#####################################################################
function check_user_root() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Check the bash shell script is being run by root or not 
    ##
    ## ARGUMENTS:
    ##   / 
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: if the bash shell script is being run by root
    ##   1: if the bash shell script is not being run by root
    ##

    ## ----- main -----

    # If ${EUID} is equal to 0 then return 0 else 1
    if [[ $EUID -eq 0 ]]; then
	echo "This script is run as root"
	return 0
    else
	echo "This script must be run as root"
	return 1
    fi

} # check_user_root

function replace_current_newer_file() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Replace the current file with a new file if available
    ##
    ## ARGUMENTS:
    ##   1: current file to replace
    ##   2: new file to replace with
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: if current file has been replaced by new file
    ##   1: if there was no replacement
    ##   2: if the argument(s) is/are null or not specified
    ##

    ## ----- main -----

    # If 2 arg are existing and not null
    if [[ "$#" == 2 ]] && [[ -n "$1" ]] && [[ -n "$2" ]]; then
	# Setup local variable within function
	local __arg1="$1"
	local __arg2="$2"
    
	# Check if file is existing
	check_file_exists ${__arg1}
    	# Storing result of the function
	local __result1="$?"

	# Check if file is existing
    	check_file_exists ${__arg2}
    	# Storing result of the function
    	local __result2="$?"

	if [[ "${__result1}" == 0 ]] && [[ "${__result2}" == 0 ]]; then
    
	    # Check if a new file is available
    	    check_new_file_available ${__arg1} ${__arg2}

    	    if [[ "$?" == 1 ]]; then
		echo "Replacing the ${__arg1} version by ${__arg2}"
		cp -f ${__arg2} ${__arg1}
		return 0
    	    fi 
	else
	    return 1
	fi
    else
	return 2
    fi
} # replace_current_newer_file

function debian-update-clean() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Update packages, upgrade packages and auto-clean
    ##   the installation of the stored packages
    ##
    ## ARGUMENTS:
    ##   /
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: if apt-get is existing
    ##   1: if apt-get is not existing
    ##   2: if the argument(s) is/are null or not specified
    ##

    ## ----- main -----

    # Checking if the script is run as root
    check_user_root
    # Storing result of the function
    local __result1="$?"

    # Setup local variable within function
    local __aptget="/usr/bin/apt-get"
    
    # Check if file is existing
    check_file_exists ${__aptget}
    # Storing result of the function
    local __result2="$?"

    # If ${__aptget} is existing and script run as root then update
    if [[ "${__result1}" == 0 ]] && [[ "${__result1}" == 0 ]]; then

        # Updating; upgrading and cleaning the debian packages

	${__aptget} -y update 
	${__aptget} -y upgrade 
	${__aptget} -y autoclean 
	return 0
    else
	echo "Exiting ..."
	return 1
    fi
} # debian-update-clean

#####################################################################
##
## ----- Error message, logs...  -----
##
#####################################################################


#####################################################################
# Test function: if yes, then test otherwise don't test
#####################################################################
function function_test() {

    ## ----- head -----
    ##
    ## DESCRIPTION:
    ##   Launch test for all functions
    ##
    ## ARGUMENTS:
    ##   1: yes to launch the tests
    ##
    ## GLOBAL VARIABLES USED:
    ##   /
    ##
    ## EXIT CODE:
    ##   0: if current file has been replaced by new file
    ##   1: if there was no replacement
    ##   2: if the argument(s) is/are null or not specified
    ##

    ## ----- main -----

    # If arg is existing and not null
    if [[ "$#" != 0 ]] && [[ -n "$1" ]]; then

	if [[ "$1" == "yes" ]]; then

	    check_file_exists .bashfunctiontest.lib.0.sh
    
    	    if [[ "$?" == 0 ]]; then
		echo "Launching the tests"
		. .bashfunctiontest.lib.0.sh
    	    fi
	fi
    else
	echo "Parameter #1 is null or not specified, aborting"
	return 2
    fi
} # function_test()

#####################################################################
##
## ----- main -----
##
#####################################################################

#function_test $FUNCTION_TO_TEST

replace_current_newer_file ${CURRENT_BASHPROFILE} ${NEWER_BASHPROFILE}
replace_current_newer_file ${CURRENT_PROFILE} ${NEWER_PROFILE}
replace_current_newer_file ${CURRENT_BASHLIBRARY} ${NEWER_BASHLIBRARY}
replace_current_newer_file ${CURRENT_BASHRC} ${NEWER_BASHRC}


#check_dir_exists2 /etc
#echo $?
#check_dir_exists2 /et
#echo $?
#check_dir_exists2
#echo $?
#echo "Test if this variable is defined $FUNCTION_TO_TEST"
#check_variable_defined $FUNCTION_TO_TEST
#echo "Test if this variable is defined $FUNCTION_TO_TEST1"
#check_variable_defined $FUNCTION_TO_TEST1
#check_variable_has_value $FUNCTION_TO_TEST
#check_variable_has_value $FUNCTION_TO_TEST1
