# flake-dir := "/home/mike/nixos-config"

# set working-directory := "/home/mike/nixos-config"

# list recipes
@default:
    just --list --unsorted

# activate current configuration
@test:
    sudo echo 'Rebuilding...'
    sudo unbuffer nixos-rebuild test --flake=. && exec $SHELL

# [arg('label', pattern='[^\s]+')]
# create git commit and add nixos generation
add comment:
    #! /usr/bin/env bash
    set -ueo pipefail
    
    # Check for unstaged changes (modified tracked files + untracked files)
    if ! git diff --quiet --exit-code || [ -n "$(git ls-files --others --exclude-standard)" ]; then
        
        echo -e '\033[33mYou have unstaged changes:\033[0m'
        git status -s
        echo
        
        read -p "Stage all changes? [y/N]: " yn
        case "$yn" in
            y*)
                git add .
                echo
                ;;
            *) 
                exit
                ;;
        esac
    
    fi

    echo -e '\033[33mAuthorize creation of git commit + nixos generation pair...\033[0m'
    sudo -v
    echo
    
    # Check for staged changes
    if ! git diff --cached --quiet --exit-code; then
        
        echo -e '\033[33mCommitting changes:\033[0m'
        git commit -m '{{comment}}' || exit
        echo

        NIXOS_LABEL="$(git rev-parse HEAD)" # current commit hash
        
        echo "Adding generation for commit $NIXOS_LABEL..."
        sudo --preserve-env=NIXOS_LABEL nixos-rebuild switch --flake=. --impure |& nom && exec $SHELL
    
    else
        
        echo "No git changes found, not adding generation"
        exit
    
    fi

# [arg('n', pattern='\d+')]
# list previous `n` generations
@list n='10':
    nixos-rebuild list-generations | tee /dev/null | head -n "$(({{n}} + 1))"
    echo '...'

