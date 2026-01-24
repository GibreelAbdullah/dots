#!/bin/bash

set -x
# Optional: Customize the prompt for verbose output (makes it stand out)
export PS4='+ [$(date +"%H:%M:%S")] '


# Define the export file location
# (Using the standard Ente CLI export path)
EXPORT_FILE="/home/gibreel_pc/Projects/Key/ente_auth.txt"

# 1. Update the export from Ente (quietly)
ente export >/dev/null 2>&1

# 2. Extract service names and let you choose via fzf
CHOICE=$(grep "otpauth://" "$EXPORT_FILE" |
  sed -e 's/.*issuer=\([^&]*\).*/\1/' |
  fzf --prompt="Ente Auth > " --height=40% --reverse --border)

# 3. If a choice was made, get the code
if [ -n "$CHOICE" ]; then
  # Extract secret and remove any trailing carriage returns
  SECRET=$(grep "$CHOICE" "$EXPORT_FILE" | sed -e 's/.*secret=\([^&]*\).*/\1/' | head -n 1 | tr -d '\r')

  # Generate code and copy to clipboard
  oathtool --totp -b "$SECRET" | wl-copy

  # Send notification
  notify-send "Ente Auth" "Code for $CHOICE copied to clipboard!"
fi
