#!/usr/bin/env bash


# =============================================================================
# Constants
# =============================================================================


# =============================================================================
# Functions
# =============================================================================

# Print the given message to the standard output.
#
# The given message will be prefixed by the current time when printed to the
# standard output.
#
# Arguments:
#   $1 - A string variable recording the given message.
printMessage() {
    local currentTime;

    currentTime=$(date +"%Y-%m-%d %H:%M:%S");

    echo -e "${currentTime}\\t${1}";
}

# Check the return code of the most recently executed command.
#
# If the return code is non-zero then exit with the given error message.
#
# Arguments:
#   $1 - A string variable recording the given error message.
checkReturnCode() {
    if [[ $? -ne 0 ]]; then
        printMessage "${1}";

        exit 1;
    fi
}


# =============================================================================
# Main
# =============================================================================

printMessage "Running jekyll build...";

bundle exec jekyll build;
checkReturnCode "Failed to run jekyll build.";

printMessage "Successfully ran jekyll build.";
