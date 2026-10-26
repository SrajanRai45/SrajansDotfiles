#!/usr/bin/env bash
# Per-window CapsLock state manager for Hyprland
# Tracks CapsLock state per window class and restores on focus change
# Requires: ydotool (with ydotoold running)

set -euo pipefail

STATE_FILE="${HOME}/.cache/hypr-capslock-state.json"
CAPSLOCK_LED="/sys/class/leds/input2::capslock/brightness"
mkdir -p "$(dirname "$STATE_FILE")"

# Load saved state
declare -A CAPS_STATE
if [[ -f "$STATE_FILE" ]]; then
    while IFS= read -r line; do
        [[ -n "$line" ]] && CAPS_STATE["${line%%:*}"]="${line##*:}"
    done < <(jq -r 'to_entries[] | "\(.key):\(.value.capslock)"' "$STATE_FILE" 2>/dev/null)
fi

save_state() {
    local tmp_file="${STATE_FILE}.tmp"
    {
        echo "{"
        local first=true
        for class in "${!CAPS_STATE[@]}"; do
            [[ "$first" == true ]] || echo ","
            first=false
            printf '  "%s": {"capslock": %s}' "$class" "${CAPS_STATE[$class]}"
        done
        echo
        echo "}"
    } > "$tmp_file"
    mv "$tmp_file" "$STATE_FILE"
}

get_capslock() {
    # Read from kernel LED interface (0 = off, 1 = on)
    [[ -r "$CAPSLOCK_LED" ]] && cat "$CAPSLOCK_LED" 2>/dev/null
}

set_capslock() {
    local target=$1
    local current
    current=$(get_capslock)
    [[ "$current" == "$target" ]] && return 0
    ydotool key 58:1 58:0 2>/dev/null
}

get_active_window() {
    hyprctl activewindow -j 2>/dev/null
}

last_window=""
last_class=""

# Handle cleanup on exit
cleanup() {
    # Save current window state before exiting
    if [[ -n "$last_window" && -n "$last_class" ]]; then
        current_caps=$(get_capslock)
        if [[ -n "$current_caps" ]]; then
            CAPS_STATE["$last_class"]=$current_caps
            save_state
        fi
    fi
    exit 0
}
trap cleanup SIGINT SIGTERM

# Verify ydotool daemon is running
if ! ydotool key 0 2>/dev/null; then
    echo "Error: ydotool daemon not running. Start with: systemctl --user start ydotool" >&2
    exit 1
fi

# Verify we can read capslock LED
if [[ ! -r "$CAPSLOCK_LED" ]]; then
    echo "Error: Cannot read $CAPSLOCK_LED" >&2
    exit 1
fi

echo "Per-window CapsLock manager started (using $CAPSLOCK_LED)"

while true; do
    window_json=$(get_active_window)
    if [[ -z "$window_json" || "$window_json" == "null" ]]; then
        sleep 0.5
        continue
    fi

    addr=$(echo "$window_json" | jq -r '.address // ""')
    class=$(echo "$window_json" | jq -r '.class // "unknown"')

    if [[ -n "$addr" && "$addr" != "$last_window" ]]; then
        # Save state for previous window
        if [[ -n "$last_window" && -n "$last_class" ]]; then
            current_caps=$(get_capslock)
            if [[ -n "$current_caps" ]]; then
                CAPS_STATE["$last_class"]=$current_caps
                save_state
            fi
        fi

        # Restore state for new window
        if [[ -n "${CAPS_STATE[$class]:-}" ]]; then
            set_capslock "${CAPS_STATE[$class]}"
        fi

        last_window=$addr
        last_class=$class
    fi

    sleep 0.2
done