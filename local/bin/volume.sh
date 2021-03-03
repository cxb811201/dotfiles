#!/usr/bin/env bash

case $BUTTON in
    1) setsid -f alacritty -e pulsemixer ;;
    2) pamixer -t ;;
    4) pamixer --allow-boost -i 1 ;;
    5) pamixer --allow-boost -d 1 ;;
    3) notify-send " 音量模块" "\- 左键点击打开pulsemixer
- 中键点击静音.
- 滑轮上下调整音量." ;;
    6) emacsclient -a "emacs" -n "$0" ;;
esac

[ "$(pamixer --get-mute)" = "true" ] && echo 🔇 && exit

vol="$(pamixer --get-volume)"

if [ "$vol" -gt "70" ]; then
    icon="🔊"
elif [ "$vol" -lt "30" ]; then
    icon="🔈"
else
    icon="🔉"
fi

echo "$icon$vol%"
