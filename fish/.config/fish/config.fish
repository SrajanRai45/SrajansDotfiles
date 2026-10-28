# --- ENVIRONMENT VARIABLES & PRIVATE PATHS ---
# Automatically loads variables from .env (root of repo or ~/.env) without committing them to Git
function __load_dotenv -d "Load environment variables from local .env"
    set -l env_locations \
        "$DOTFILES_DIR/.env" \
        "$HOME/Repositories/SrajansDotfiles/.env" \
        "$HOME/dotfiles/.env" \
        "$HOME/.config/dotfiles/.env" \
        "$HOME/.env"

    for env_file in $env_locations
        if test -f "$env_file"
            for line in (cat "$env_file")
                set -l trimmed (string trim "$line")
                if test -z "$trimmed"; or string match -qr '^#' "$trimmed"
                    continue
                end
                set -l parts (string split -m 1 = "$trimmed")
                if test (count $parts) -eq 2
                    set -l key (string trim "$parts[1]")
                    set -l val (string trim "$parts[2]")
                    set val (string trim -c "\"'" "$val")
                    set val (string replace -a '$HOME' "$HOME" "$val")
                    set val (string replace -r '^~(?=/|$)' "$HOME" "$val")
                    set -gx "$key" "$val"
                end
            end
            break
        end
    end
end
__load_dotenv

if status is-interactive
    # Prompt Initialization (Switched from Caelestia's default Starship to your Oh My Posh)
    # starship init fish | source
    oh-my-posh init fish --config ~/.cache/oh-my-posh/themes/jandedobbeleer.omp.json | source
    #PATH 
    fish_add_path ~/.local/bin
    fish_add_path /usr/lib/qt6/bin
    set -gx QML2_IMPORT_PATH /usr/lib/qt6/qml

    # Custom tool paths (loaded dynamically if defined in .env)
    set -q SPICETIFY_DIR; and test -d "$SPICETIFY_DIR"; and fish_add_path "$SPICETIFY_DIR"

    # Example optional user paths (uncomment and customize if using custom bin dirs):
    # set -gx PATH "$HOME/.local/bin" $PATH

    # Direnv + Zoxide 
    # (Note: '--cmd cd' automatically makes 'cd' act like 'z', so you don't need a separate alias)
    command -v direnv &>/dev/null && direnv hook fish | source
    command -v zoxide &>/dev/null && zoxide init fish --cmd cd | source

    # --- CUSTOM ALIASES ---
    alias grep='grep --color=auto'

    # Tool Aliases (Uncomment and install the respective tools if desired)
    # alias ls="eza --icons --group-directories-first"
    # alias ll="eza -lh --icons --group-directories-first"
    # alias la="eza -a --icons --group-directories-first"
    # alias tree="eza --tree --icons"
    # alias dev="zellij --layout ~/.config/zellij/layouts/ide.kdl"
    # alias tw="taskwarrior-tui"
    # alias lutris="/usr/bin/python3 /usr/bin/lutris"
    # Waydroid Aliases
    # alias wd="/usr/bin/python3 /usr/bin/waydroid  show-full-ui"
    # alias wd-kill="/usr/bin/python3 /usr/bin/waydroid  session stop"
    # CPU Power Limiter (requires ryzenadj)
    # alias limitCpuPower="sudo ryzenadj --stapm-limit=40000 --fast-limit=40000 --slow-limit=40000"
    # Live Wallpaper (requires mpvpaper)
    # alias LiveWallpaperMpvpaper='mpvpaper -o "loop --no-audio --panscan=1" "*"'

    # --- TOOL & WORKFLOW ABBREVIATIONS ---
    # abbr n nvim
    # abbr lg lazygit

    # Git Abbreviations (Kept from Caelestia defaults - uncomment to enable)
    # abbr gd 'git diff'
    # abbr ga 'git add .'
    # abbr gc 'git commit -m'
    # abbr gl 'git log'
    # abbr gs 'git status'
    # abbr gst 'git stash'
    # abbr gsp 'git stash pop'
    # abbr gp 'git push'
    # abbr gpl 'git pull'
    # abbr gsw 'git switch'
    # abbr gsm 'git switch main'
    # abbr gb 'git branch'
    # abbr gbd 'git branch -d'
    # abbr gco 'git checkout'
    # abbr gsh 'git show'

    # Sourcing local uncommitted fish configurations (aliases, private functions)
    test -f "$HOME/.config/fish/config.local.fish"; and source "$HOME/.config/fish/config.local.fish"

end
mise activate fish | source
