#!/bin/bash
# Screenshot script for mango - area selection, saves to file and copies to clipboard

FILE=~/Pictures/Screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png
grim -g "$(slurp)" "$FILE" && wl-copy < "$FILE" && notify-send "Screenshot saved & copied"
