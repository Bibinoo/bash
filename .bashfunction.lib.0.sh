#!/bin/bash -x

#####################################################################
# Functions
#####################################################################
function check_arg_exists () {
    if [[ "$#" -eq 0 ]] ; then
	echo "Parameter #1 doesn't exist, aborting"
	return 2
    fi
}


function check_dir_exists () {

    # Check if arg is existing
    echo "Before"
    check_arg_exists $1

    # If arg existing then continue
    if [[ $? == 0 ]]; then
	echo "in the loop"
	# Setup local variable within function
	local __arg1="$1"
    	
	# Check if the dir and/or file is existing
	if [ -d $__arg1 ]; then
	    echo "$__arg1 is existing"
   	else
	    echo "$__arg1 is not existing"
	    return 1
	fi
    fi
}

function check_file_exists () {

    # Check if arg is existing
    check_arg_exists $1

    # If arg existing then continue
    if test $? == 0; then

	# Setup local variable within function
	local __arg1="$1"
    	
	# Check if the dir and/or file is existing
	if [ -f $__arg1 ]; then
	    echo "$__arg1 is existing"
   	else
	    echo "$__arg1 is not existing"
	    return 1
	fi
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

#check_file_exists_test
check_dir_exists_test
#check_arg_exists
