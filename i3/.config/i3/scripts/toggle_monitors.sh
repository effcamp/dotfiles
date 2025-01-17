#!/bin/bash

# Function to check if a specific resolution and refresh rate is available
check_resolution() {
    local output=$1
    local res=$2
    local rate=$3
    xrandr | grep "^$output" -A 20 | grep -q "$res.*$rate"
    return $?
}

# Function to detect active output (HDMI-0 or DP-0)
detect_active_output() {
    if xrandr | grep "^HDMI-0 connected" >/dev/null; then
        echo "HDMI-0"
    elif xrandr | grep "^DP-0 connected" >/dev/null; then
        echo "DP-0"
    else
        echo "No supported output detected" >&2
        exit 1
    fi
}

# Function to set the best available resolution
set_best_resolution() {
    local output=$1
    
    # Try resolutions in order of preference
    # if check_resolution "$output" "7680x2160" "120.00"; then
    #     xrandr --output "$output" --mode 7680x2160 --rate 120.00
    # el
    if check_resolution "$output" "3840x2160" "59.94"; then
        xrandr --output "$output" --mode 3840x2160 --rate 59.94
    else
        # Fallback to auto if preferred resolutions aren't available
        xrandr --output "$output" --auto
    fi
}

# Function to reset to default configuration
reset_config() {
    # First reset the output to preferred mode
    ACTIVE_OUTPUT=$(detect_active_output)
    set_best_resolution "$ACTIVE_OUTPUT"

    # Only try to delete monitors if they exist
    if xrandr --listmonitors | grep -q "MID"; then
        xrandr --delmonitor RIGHT
        xrandr --delmonitor MID
        xrandr --delmonitor LEFT
        xrandr --delmonitor LEFT-BOT
    fi
    exit 0
}

# Parse command line arguments
while [ "$1" != "" ]; do
    case $1 in
        -r | --reset )    reset_config
                         ;;
        * )              break
    esac
    shift
done

# Detect active output
ACTIVE_OUTPUT=$(detect_active_output)

# Check current layout
CURRENT_LAYOUT=$(xrandr --listmonitors | grep -c "MID")

if [ $CURRENT_LAYOUT -eq 0 ]; then
    # If not in multi-monitor layout, switch to it
    xrandr --output "$ACTIVE_OUTPUT" --mode 7680x2160
    xrandr --setmonitor RIGHT 2180/1x2160/1+5500+0 "$ACTIVE_OUTPUT"
    xrandr --setmonitor MID 3800/1x2160/1+1700+0 none
    xrandr --setmonitor LEFT 1700/1x1080/1+0+0 none
    xrandr --setmonitor LEFT-BOT 1700/1x1080/1+0+1080 none
fi
