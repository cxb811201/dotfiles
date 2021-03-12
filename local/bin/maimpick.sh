#!/usr/bin/env bash
set -euo pipefail

declare -a options=(
    "Selected area"
    "Current window"
    "Full screen"
    "Selected area (copy)"
    "Current window (copy)"
    "Full screen (copy)"
)

choice=$(printf '%s\n' "${options[@]}" | dmenu -c -l 6 -i -p "Take screenshot of:")

case $choice in
    "Selected area")
        pfile=$(xdg-user-dir PICTURES)/pic-selected-"$(date '+%y%m%d-%H%M-%S').png"
        maim -s "$pfile" && sxiv -N Screenshot "$pfile"
        unset pfile
        ;;
    "Current window")
        pfile=$(xdg-user-dir PICTURES)/pic-window-"$(date '+%y%m%d-%H%M-%S').png"
        maim -i "$(xdotool getactivewindow)" "$pfile" && sxiv -N Screenshot "$pfile"
        unset pfile
        ;;
    "Full screen")
        pfile=$(xdg-user-dir PICTURES)/pic-full-"$(date '+%y%m%d-%H%M-%S').png"
        maim "$pfile" && sxiv -N Screenshot "$pfile"
        unset pfile
        ;;
    "Selected area (copy)")
        maim -s | xclip -selection clipboard -t image/png
        ;;
    "Current window (copy)")
        maim -i "$(xdotool getactivewindow)" | xclip -selection clipboard -t image/png
        ;;
    "Full screen (copy)")
        maim | xclip -selection clipboard -t image/png
        ;;
esac
