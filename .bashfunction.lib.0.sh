#!/bin/bash
#set -E
#####################################################################
# Global Variables
#####################################################################
FUNCTION_TO_TEST="no"
CURRENT_FILE=~/.profile
NEWER_FILE=~/home-repo/.profile

#####################################################################
# Functions directory and files
#####################################################################
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
    ##   2: if the argument(s) is/are null or not specified
    ##

    ## ----- main -----

    # If arg existing and greater than nothing then continue
    if [[ "$#" != 0 ]] && [[ -n "$1" ]]; then

	# Setup local variable within function
	local __arg1="$1"
    	
	# Check if the dir and/or file is existing
	if [ -d "$__arg1" ]; then
	    echo "Directory $__arg1 is existing"
	    return 0
   	else
	    echo "Directory $__arg1 is not existing. Returning 1 and exiting the function"
	    return 1
	fi
    else
	echo "Parameter #1 is null or not specified, aborting"
	return 2
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
    ##   2: if the argument(s) is/are null or not specified
    ##

    ## ----- main -----
    # If arg existing and greater than nothing then continue
    if [[ "$#" != 0 ]] && [[ -n "$1" ]]; then

	# Setup local variable within function
	local __arg1="$1"
    	
	# Check if the dir and/or file is existing
	if [ -f "$__arg1" ]; then
	    echo "File $__arg1 is existing"
	    return 0
   	else
	    echo "File $__arg1 is not existing. Returning 1 and exiting the function"
	    return 1
	fi
    else
	echo "Parameter #1 is null or not specified, aborting"
	return 2
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
	
	if [[ "$__arg1" -ot "$__arg2" ]]; then
	    echo "$__arg1 is older than $__arg2"
	    return 1 # True
	else
	    echo "There is no new available file for $__arg1"
	    return 0 # False
	fi
    else
	echo "Parameter #1 or/and #2 is null or not specified, aborting"
	return 2
    fi
} # check_new_file_available()

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
	check_file_exists $__arg1
    	# Storing result of the function
	local __result1=$?

	# Check if file is existing
    	check_file_exists $__arg2
    	# Storing result of the function
    	local __result2=$?

	if [[ "$__result1" == 0 ]] && [[ "$__result2" == 0 ]]; then
    
	    # Check if a new file is available
    	    check_new_file_available $__arg2 $__arg1

    	    if [[ "$?" == 1 ]]; then
		cp -v -f $__arg1 $__arg2
		return 0
    	    fi 
	else
	    return 1
	fi
    else
	return 2
    fi
} # replace_current_newer_file

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

function_test $FUNCTION_TO_TEST

replace_current_newer_file $CURRENT_FILE $NEWER_FILE
