#!/bin/bash
#####################################################################
# Variables
#####################################################################
FUNCTION_TO_TEST="yes"

#####################################################################
# Functions directory and files
#####################################################################
function check_dir_exists () {

    # If arg existing and greater than nothing then continue
    if [[ "$#" != 0 ]] && [[ -n "$1" ]]; then

	# Setup local variable within function
	local __arg1="$1"
    	
	# Check if the dir and/or file is existing
	if [ -d $__arg1 ]; then
	    echo "Directory $__arg1 is existing"
	    return 0
   	else
	    echo "Directory $__arg1 is not existing"
	    return 1
	fi
    else
	echo "Parameter #1 is null or doesn't exist, aborting"
	return 2
    fi
}

function check_file_exists () {

    # If arg existing and greater than nothing then continue
    if [[ "$#" != 0 ]] && [[ -n "$1" ]]; then

	# Setup local variable within function
	local __arg1="$1"
    	
	# Check if the dir and/or file is existing
	if [ -f $__arg1 ]; then
	    echo "File $__arg1 is existing"
	    return 0
   	else
	    echo "File $__arg1 is not existing"
	    return 1
	fi
    else
	echo "Parameter #1 is null or doesn't exist, aborting"
	return 2
    fi
}

#####################################################################
# Test function: if yes, then test otherwise don't test
#####################################################################
function function_test () {

    # If arg existing and greater than nothing then continue
    if [[ "$#" != 0 ]] && [[ -n "$1" ]]; then

	if [[ "$1" == "yes" ]]; then

	    check_file_exists .bashfunctiontest.lib.0.sh
    
    	    if [[ "$?" == 0 ]]; then
		echo "Launching the tests"
		. .bashfunctiontest.lib.0.sh
    	    fi
	fi
    else
	echo "Parameter #1 is null or doesn't exist, aborting"
	return 2
    fi
}

function_test $FUNCTION_TO_TEST
