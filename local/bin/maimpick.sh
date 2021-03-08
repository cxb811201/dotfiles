#!/usr/bin/env bash

declare -a options=("selected area
current window
full screen
selected area (copy)
current window (copy)
full screen (copy)")

choice=$(echo -e "${options[@]}" | dmenu -c -l 6 -i -p "Screenshot which area?")

case $choice in
    "selected area")
        pfile=$(xdg-user-dir PICTURES)/pic-selected-"$(date '+%y%m%d-%H%M-%S').png"
        maim -s "$pfile" && sxiv -N Screenshot "$pfile"
        unset pfile
        ;;
    "current window")
        pfile=$(xdg-user-dir PICTURES)/pic-window-"$(date '+%y%m%d-%H%M-%S').png"
        maim -i "$(xdotool getactivewindow)" "$pfile" && sxiv -N Screenshot "$pfile"
        unset pfile
        ;;
    "full screen")
        pfile=$(xdg-user-dir PICTURES)/pic-full-"$(date '+%y%m%d-%H%M-%S').png"
        maim "$pfile" && sxiv -N Screenshot "$pfile"
        unset pfile
        ;;
    "selected area (copy)")
        maim -s | xclip -selection clipboard -t image/png
        ;;
    "current window (copy)")
        maim -i "$(xdotool getactivewindow)" | xclip -selection clipboard -t image/png
        ;;
    "full screen (copy)")
        maim | xclip -selection clipboard -t image/png
        ;;
esac
