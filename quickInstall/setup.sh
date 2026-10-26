#!/bin/sh

# Define ANSI colors for better readability (POSIX compatible printf)
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Dynamically determine the base directory relative to this script
# (or uncomment and set an explicit path, e.g. BASE_DIR="$HOME/dotfiles/quickInstall")
# Example:
# BASE_DIR="/path/to/your/dotfiles/quickInstall"
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Navigate to the base directory or exit if it fails
cd "$BASE_DIR" || {
  printf "%bFailed to find directory %s%b\n" "$RED" "$BASE_DIR" "$NC"
  exit 1
}

printf "%bStarting Maestro setup execution...%b\n\n" "$BLUE" "$NC"

# Loop through all .sh files found inside subdirectories
for script in */*.sh; do
  # Verify it is actually a file
  if [ -f "$script" ]; then
    printf "%b======================================%b\n" "$BLUE" "$NC"
    printf "%bExecuting: %s%b\n" "$GREEN" "$script" "$NC"
    printf "%b======================================%b\n" "$BLUE" "$NC"

    # Run the script using POSIX sh
    if sh "./$script"; then
      printf "%b✓ Successfully completed: %s%b\n\n" "$GREEN" "$script" "$NC"
    else
      printf "%b✗ Error occurred while running: %s%b\n\n" "$RED" "$script" "$NC"
    fi
  fi
done

printf "%bAll installation tasks are complete!%b\n" "$BLUE" "$NC"
