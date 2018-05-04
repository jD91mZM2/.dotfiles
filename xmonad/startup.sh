#!/bin/sh

# Setup

~/.screenlayout/default.sh
xsetroot -cursor_name left_ptr
xinput disable "$(xinput list | grep Touchpad | cut -d '=' -f 2 | cut -d $'\t' -f 1)"
~/.fehbg
# Note: feh has to be after screenlayout

# Background

compton -b
udiskie &
~/.dotfiles/lock-timer.sh slock &

# Interactive

"$DEJA_DUP_MONITOR" &
Discord &
dropbox start &
konsole &
liferea &
chromium --app="https://chat.redox-os.org/" &
nm-applet &
thunderbird &
xfce4-panel --disable-wm-check &