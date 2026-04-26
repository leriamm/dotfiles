#!/bin/bash
# Reload script for mango + noctalia

# Reload mango config
mango -c ~/.config/mango/config.conf -p && mmsg -d reload_config
sleep 0.5

# Restart noctalia-shell
killall qs 2>/dev/null
sleep 0.5
qs -c noctalia-shell &

