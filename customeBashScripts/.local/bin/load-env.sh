#!/usr/bin/env bash
# ==============================================================================
# load-env.sh - Universal .env loader for custom Bash/POSIX scripts
# Usage inside any script:
#   [ -f "$HOME/.local/bin/load-env.sh" ] && . "$HOME/.local/bin/load-env.sh"
# ==============================================================================

load_dotfiles_env() {
    local env_locations=(
        "${DOTFILES_DIR:-}/.env"
        "$HOME/Repositories/SrajansDotfiles/.env"
        "$HOME/dotfiles/.env"
        "$HOME/.config/dotfiles/.env"
        "$HOME/.env"
    )

    for env_file in "${env_locations[@]}"; do
        if [ -n "$env_file" ] && [ -f "$env_file" ]; then
            set -a
            while IFS= read -r line || [ -n "$line" ]; do
                line="${line#"${line%%[![:space:]]*}"}"
                line="${line%"${line##*[![:space:]]}"}"
                case "$line" in
                    \#*|"") continue ;;
                    *) eval "export $line" ;;
                esac
            done < "$env_file"
            set +a
            break
        fi
    done
}

load_dotfiles_env
