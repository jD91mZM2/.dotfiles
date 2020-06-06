#!/bin/sh

cd
# Setup

xsetroot -cursor_name left_ptr

# Always running

~/dotfiles/scripts/lock-timer.sh slock &
nm-applet &

# Applications

thunderbird &
xfce4-power-manager &

st -e tmux &
sleep 1 # wait for terminal to statup
emacs &
st -e weechat &

chromium --app="https://chat.redox-os.org/" &
sleep 10 # chrome doesn't handle stress well apparently
chromium --app="https://discordapp.com/channels/@me" &