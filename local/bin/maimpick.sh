#!/bin/sh

# This is bound to Shift+PrintScreen by default, requires maim. It lets you
# choose the kind of screenshot to take, including copying the image or even
# highlighting an area to copy. scrotcucks on suicidewatch right now.

case "$(printf "a selected area\\ncurrent window\\nfull screen\\na selected area (copy)\\ncurrent window (copy)\\nfull screen (copy)" | dmenu -c -l 6 -i -p "Screenshot which area?")" in
    "a selected area")
        pfile=$(xdg-user-dir PICTURES)/pic-selected-"$(date '+%y%m%d-%H%M-%S').png"
        maim -s "$pfile" && sxiv -N Screenshot "$pfile"
        unset pfile
        ;;
    "current window")
        pfile=$(xdg-user-dir PICTURES)/pic-selected-"$(date '+%y%m%d-%H%M-%S').png"
        maim -i "$(xdotool getactivewindow)" "$pfile" && sxiv -N Screenshot "$pfile"
        unset pfile
        ;;
    "full screen")
        pfile=$(xdg-user-dir PICTURES)/pic-selected-"$(date '+%y%m%d-%H%M-%S').png"
        maim "$pfile" && sxiv -N Screenshot "$pfile"
        unset pfile
        ;;
    "a selected area (copy)")
        maim -s | xclip -selection clipboard -t image/png
        ;;
    "current window (copy)")
        maim -i "$(xdotool getactivewindow)" | xclip -selection clipboard -t image/png
        ;;
    "full screen (copy)")
        maim | xclip -selection clipboard -t image/png
        ;;
esac
