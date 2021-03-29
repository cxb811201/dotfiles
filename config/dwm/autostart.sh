#!/usr/bin/env bash

setsid -f xsetroot -cursor_name left_ptr

setsid -f xset s off -dpms

if ! pgrep -u $UID -x dunst > /dev/null; then
    setsid -f dunst
fi

if ! pgrep -u $UID -x picom > /dev/null; then
    setsid -f picom --config ~/.config/picom.conf
fi

if ! pgrep -u $UID -x dwmblocks > /dev/null; then
    setsid -f dwmblocks
fi

setsid -f nitrogen --restore

setsid -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

# Remove mouse when idle
if ! pgrep -u $UID -x unclutter > /dev/null; then
    setsid -f unclutter
fi

if ! pgrep -u $UID -x fcitx5 > /dev/null; then
    setsid -f fcitx5
fi

if ! pgrep -u $UID -x qv2ray > /dev/null; then
    sleep 1

    if pgrep -u $UID -x xray > /dev/null; then
        killall -q xray
    fi

    while pgrep -u $UID -x xray >/dev/null; do sleep 1; done

    setsid -f qv2ray
fi
