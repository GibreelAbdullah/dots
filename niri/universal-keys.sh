#!/bin/bash
ACTION=$1 # copy, paste, or cut

# Detect the active window's app_id/class using niri msg
# We look for common terminal names. Add yours to the list.
ACTIVE_APP=$(niri msg --json windows | jq -r '.[] | select(.is_focused == true) | .app_id')

TERMINALS="ghostty"

if [[ "$ACTIVE_APP" =~ ($TERMINALS) ]]; then
  # Terminal Logic
  case $ACTION in
  copy) wtype -M ctrl -M shift c -m shift -m ctrl ;;
  paste) wtype -M ctrl -M shift v -m shift -m ctrl ;;
  cut) wtype -M ctrl -M shift x -m shift -m ctrl ;; # Note: Cut rarely exists in terminals
  esac
else
  # Standard GUI Logic
  case $ACTION in
  copy) wtype -M ctrl c -m ctrl ;;
  paste) wtype -M ctrl v -m ctrl ;;
  cut) wtype -M ctrl x -m ctrl ;;
  esac
fi
