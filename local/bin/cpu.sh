#!/usr/bin/env bash

case $BUTTON in
	1) notify-send "🖥 CPU hogs" "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head)\\n(100% per core)" ;;
	2) setsid -f alacritty -e bashtop ;;
	3) notify-send "🖥 CPU模块" "\- 查看CPU温度.
- 左键点击查看CPU占用率.
- 中键点击打开bashtop." ;;
	6) emacsclient -a "emacs" -n "$0" ;;
esac

sensors | awk '/Package id 0/ {print "🌡" $4}'
