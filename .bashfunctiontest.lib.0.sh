#!/bin/bash

#####################################################################
# Functions to test
#####################################################################
function check_dir_exists_test () {
    check_dir_exists ~/home-repo
    check_dir_exists ~/homerepo
    check_dir_exists ""
    check_dir_exists
}

function check_file_exists_test () {
    check_file_exists ~/home-repo/.profile
    check_file_exists ~/home-repo/.profile1
    check_file_exists ""
    check_file_exists
}

function function_test () {
check_dir_exists_test
check_file_exists_test
}

function_test
