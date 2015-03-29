#/bin/bash

#####################################################################
# Functions
#####################################################################
function check_arg_exists () {
    if [ -z "$1" ]; then
	echo "Parameter #1 doesn't exist, aborting"
    fi
    return $?
}


function check_dir_exists () {
    local dir="$1"
    if [ -d $dir ]; then
	echo "$dir is existing"
    else
	echo "$dir is not existing"
	return $?
    fi
}

function check_file_exists () {
    local __var1="$1"
    if [ -f $__var1 ]; then
	echo "$__var1 is existing"
    else
	echo "$__var1 is not existing"
	return 1
    fi
}
check_dir_exists ~/home-repo
echo $?
check_file_exists ~/home-repo/.profile
echo $?
