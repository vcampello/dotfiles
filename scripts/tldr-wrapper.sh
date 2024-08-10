#!/bin/zsh

# A tldr wrapper to preload examples on the prompt
# Only works in zsh (see last line)
helpwith() {
    # no arguments
    if [[ $# == 0 ]]; then
        tldr --help
        return
    fi

    # grab tldr output
    result=$(tldr $@)

    # output and return if unsuccessful
    if [[ $? != 0 ]]; then
        echo $result
        return -1
    fi

    # find the examples and trim whitespace
    parsed=$(echo $result | grep -e "^  " | awk '{$1=$1};1')

    # exit if there's nothing to display
    if [[ -z $parsed ]]; then
        echo $result
        return
    fi

    # preload selected example into the promp
    print -zn $(echo $parsed | fzf)
}
