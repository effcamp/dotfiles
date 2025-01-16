#!/bin/bash

# Toggle between layouts
CURRENT_LAYOUT=$(xrandr --listmonitors | grep -c "MID")

# if [ $CURRENT_LAYOUT -eq 0 ]; then
#     # If not in multi-monitor layout, switch to it
#     xrandr --output HDMI-0 --mode 7680x2160
#     xrandr --setmonitor RIGHT 2180/1x2160/1+5500+0 HDMI-0
#     xrandr --setmonitor LEFT 1700/1x2160/1+0+0 none
#     xrandr --setmonitor MID 3800/1x2160/1+1700+0 none
# fi

# if [ $CURRENT_LAYOUT -eq 0 ]; then
#     # If not in multi-monitor layout, switch to it
#     xrandr --output HDMI-0 --mode 7680x2160
#     xrandr --setmonitor RIGHT 2180/1x2160/1+5500+0 HDMI-0
#     xrandr --setmonitor MID 3800/1x2160/1+1700+0 none
#     xrandr --setmonitor LEFT 1700/1x1080/1+0+0 none
#     xrandr --setmonitor LEFT-BOT 1700/1x1080/1+0+1080 none
# fi

if [ $CURRENT_LAYOUT -eq 0 ]; then
    # If not in multi-monitor layout, switch to it
    xrandr --output DP-0 --mode 7680x2160
    xrandr --setmonitor RIGHT 2180/1x2160/1+5500+0 DP-0
    xrandr --setmonitor MID 3800/1x2160/1+1700+0 none
    xrandr --setmonitor LEFT 1700/1x1080/1+0+0 none
    xrandr --setmonitor LEFT-BOT 1700/1x1080/1+0+1080 none
fi
# if [ $CURRENT_LAYOUT -eq 0 ]; then
#     # Set the resolution for the physical output
#     xrandr --output HDMI-0 --mode 7680x2160
#
#     # Define virtual monitors with correct associations
#     xrandr --setmonitor RIGHT 2180/1x2160/1+5500+0 HDMI-0
#     xrandr --setmonitor MID 3800/1x2160/1+1700+0 HDMI-0
#     xrandr --setmonitor LEFT 1700/1x1080/1+0+0 HDMI-0
#     xrandr --setmonitor LEFT-BOT 1700/1x1080/1+0+1080 HDMI-0
# fi
