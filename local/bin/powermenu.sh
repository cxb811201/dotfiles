#!/usr/bin/env bash
set -euo pipefail

declare -a options=(
    "Lock screen"
    "Logout"
    "Reboot"
    "Shutdown"
)

yesno(){
    # shellcheck disable=SC2005
    echo "$(echo -e "No\nYes" | dmenu -c -l 2 -i -p "${1}")"
}

# Piping the above array into dmenu.
# We use "printf '%s\n'" to format the array one item to a line.
choice=$(printf '%s\n' "${options[@]}" | dmenu -c -l 4 -i -p 'Power menu:')

# What to do when/if we choose one of the options.
case $choice in
    'Logout')
        if [[ $(yesno "Logout?") == "Yes" ]]; then
            dwmc quit
        fi
        ;;
    'Lock screen')
        betterlockscreen -l
        ;;
    'Reboot')
        if [[ $(yesno "Reboot?") == "Yes" ]]; then
            systemctl reboot
        fi
        ;;
    'Shutdown')
        if [[ $(yesno "Shutdown?") == "Yes" ]]; then
            systemctl poweroff
        fi
        ;;
esac
