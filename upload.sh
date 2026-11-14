#!/usr/bin/env bash
# Screenshot → Upload → Clipboard
# Configure the variables below, then bind this script to a hotkey.

# --- Configuration ---
# Settings are read from a config file outside the repo (never committed).
# Default: ${XDG_CONFIG_HOME:-$HOME/.config}/picture-upload/config
# Override with: PICTURE_UPLOAD_CONFIG=/path/to/config
# See config.example for all variables.
CONFIG_FILE="${PICTURE_UPLOAD_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/picture-upload/config}"

SFTP_HOST=""
SFTP_USER=""
SFTP_REMOTE_PATH=""
BASE_URL=""
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
SFTP_KEY=""

if [[ -f "$CONFIG_FILE" ]]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
fi

# --- Script ---
set -euo pipefail

TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
FILENAME="${TIMESTAMP}.jpg"
LOCAL_FILE="${SCREENSHOT_DIR}/${FILENAME}"

for var in SFTP_HOST SFTP_USER SFTP_REMOTE_PATH BASE_URL; do
    if [[ -z "${!var}" ]]; then
        echo "Missing setting $var. Create $CONFIG_FILE (see config.example)." >&2
        exit 1
    fi
done

mkdir -p "$SCREENSHOT_DIR"

# Open Spectacle in interactive region-capture mode; blocks until done
spectacle --region --background --output "$LOCAL_FILE" 2>/dev/null

# Abort if no file was created (user cancelled)
if [[ ! -f "$LOCAL_FILE" ]]; then
    notify-send "Screenshot" "Cancelled — nothing uploaded." --icon=dialog-error
    exit 1
fi

# Build scp command
SCP_OPTS=(-q)
[[ -n "$SFTP_KEY" ]] && SCP_OPTS+=(-i "$SFTP_KEY")

if ! scp "${SCP_OPTS[@]}" "$LOCAL_FILE" "${SFTP_USER}@${SFTP_HOST}:${SFTP_REMOTE_PATH}/${FILENAME}"; then
    notify-send "Screenshot" "Upload failed!" --icon=dialog-error
    exit 1
fi

PUBLIC_URL="${BASE_URL}/${FILENAME}"

# Copy URL to clipboard (supports both Wayland and X11)
if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    printf '%s' "$PUBLIC_URL" | wl-copy
else
    printf '%s' "$PUBLIC_URL" | xclip -selection clipboard
fi

notify-send "Screenshot uploaded" "$PUBLIC_URL" --icon=dialog-information
