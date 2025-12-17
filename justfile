# flake-dir := "/home/mike/nixos-config"

# set working-directory := "/home/mike/nixos-config"

# list recipes
@default:
    just --list --unsorted

# activate current configuration
@test:
    sudo echo 'Rebuilding...'
    sudo unbuffer nixos-rebuild test --flake=. |& nom && exec $SHELL

# [arg('label', pattern='[^\s]+')]
# create git commit and add nixos generation
add label comment:
    #! /usr/bin/env bash
    set -ueo pipefail
    if git diff --quiet --exit-code; then
        git commit -m 'nixos "{{label}}": {{comment}}'
        sudo echo 'Rebuilding...'
        NIXOS_LABEL='{{label}}' sudo --preserve-env=NIXOS_LABEL unbuffer nixos-rebuild switch --flake=. --impure |& nom && exec $SHELL
    else
        echo -e "\033[33mPlease stage all changes before adding the configuration:\033[0m"
        git status -s
    fi

# [arg('n', pattern='\d+')]
# list previous `n` generations
@list n='10':
    nixos-rebuild list-generations | tee /dev/null | head -n "$(({{n}} + 1))"
    echo '...'

