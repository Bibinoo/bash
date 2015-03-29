#!/bin/bash

#####################################################################
# Functions
#####################################################################
function check_dir_exists () {

    # If arg existing and greater than nothing then continue
    if [[ "$#" != 0 ]] && [ ! -z "$1" ]; then

	# Setup local variable within function
	local __arg1="$1"
    	
	# Check if the dir and/or file is existing
	if [ -d $__arg1 ]; then
	    echo "$__arg1 is existing"
	    return 0
   	else
	    echo "$__arg1 is not existing"
	    return 1
	fi
    else
	echo "Parameter #1 is null or doesn't exist, aborting"
	return 2
    fi
}

function check_file_exists () {

    # If arg existing and greater than nothing then continue
    if [[ "$#" != 0 ]] && [ ! -z "$1" ]; then

	# Setup local variable within function
	local __arg1="$1"
    	
	# Check if the dir and/or file is existing
	if [ -f $__arg1 ]; then
	    echo "$__arg1 is existing"
	    return 0
   	else
	    echo "$__arg1 is not existing"
	    return 1
	fi
    else
	echo "Parameter #1 is null or doesn't exist, aborting"
	return 2
    fi
}

function check_file_exists_test () {
    check_file_exists ~/home-repo/.profile
    check_file_exists ~/home-repo/.profile1
    check_file_exists ""
    check_file_exists
}

function check_dir_exists_test () {
    check_dir_exists ~/home-repo
    check_dir_exists ~/homerepo
    check_dir_exists ""
    check_dir_exists
}

function function_test () {
check_file_exists_test
check_dir_exists_test
}

function_test
