if status is-interactive
    # Prompt Initialization (Switched from Caelestia's default Starship to your Oh My Posh)
    # starship init fish | source
    oh-my-posh init fish --config ~/.cache/oh-my-posh/themes/jandedobbeleer.omp.json | source
    #PATH 
    fish_add_path ~/.local/bin
    fish_add_path /usr/lib/qt6/bin
    set -gx QML2_IMPORT_PATH /usr/lib/qt6/qml

    # Example optional user paths (uncomment and customize if using Spicetify or custom bin dirs):
    # fish_add_path ~/.spicetify
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

end
mise activate fish | source
