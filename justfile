# flake-dir := "/home/mike/nixos-config"

# set working-directory := "/home/mike/nixos-config"

# list recipes
[private]
@default:
    just --list --unsorted


# activate current configuration
@test:
    sudo -v
    sudo nixos-rebuild test --flake=. |& nom && exec $SHELL


# add nixos generation with current commit hash, or custom label if provided
add label='':
    #! /usr/bin/env bash
    set -ueo pipefail

    label='{{label}}'

    if ! [[ "$label" =~ ^[a-zA-Z0-9:_\.-]*$ ]]; then
        echo -e "\033[33mInvalid label, may only contain letters, numbers, or the symbols \":\" \"_\" \".\" \"-\" \033[0m"
        exit
    fi

    # add generation with provided label
    if [ -n "$label" ]; then
        sudo -v
        echo -e "\033[33mAdding generation: $label\033[0m"
        NIXOS_LABEL="$label" sudo --preserve-env=NIXOS_LABEL \
          nixos-rebuild switch --flake=. --impure |& nom && exec $SHELL
        
        exit
    fi

    # ensure repo is clean before proceeding
    if [ -n "$(git status --porcelain)" ]; then
        echo -e '\033[33mRepository must be clean, you have uncommitted changes:\033[0m'
        git status -s
        
        exit
    fi

    # add generation with current commit hash as label
    just add "$(git rev-parse HEAD)"


# list n generations
list n='10':
    #! /usr/bin/env bash
    set -ueo pipefail

    if [[ '{{n}}' =~ ^[0-9]+$ ]]; then
        nixos-rebuild list-generations | tee /dev/null | head -n "$(({{n}} + 1))"
        echo '...'
    else
        echo 'Invalid argument, "{{n}}" is not a number'
        exit
    fi

