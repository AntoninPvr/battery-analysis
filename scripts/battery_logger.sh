#!/bin/bash

# Author: AntoninPvr
# Date: 2024-12-04
# License: GPLv3
# Purpose: This script was originally designed to log battery information for a Razer Blade 15 Advanced (2020).
# It supports flexible logging with an optional terminal interface showing the current log size and latest data.

# Default values
LOG_FILE="battery_log.csv"
INTERVAL=60
BATTERY_PATH=$(find /sys/class/power_supply/ -name "BAT*" | head -n 1)
MAX_TIME=0  # 0 indicates indefinite runtime
DISPLAY_INTERFACE=1  # 1 to display interface, 0 to disable

# Function to display help
show_help() {
    echo "Usage: $0 [-o OUTPUT_FILE] [-i INTERVAL] [-b BATTERY_PATH] [-t MAX_TIME] [--no-interface]"
    echo
    echo "  -o, --output       Specify the output file (default: battery_log.csv)"
    echo "  -i, --interval     Specify the logging interval in seconds (default: 60)"
    echo "  -b, --battery      Specify the battery path (default: autodetected)"
    echo "  -t, --time         Specify the maximum runtime in seconds (default: indefinite)"
    echo "      --no-interface Disable the terminal interface (default: enabled)"
    echo "  -h, --help         Display this help message"
    exit 0
}

# Parse named arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            LOG_FILE="$2"
            shift 2
            ;;
        -i|--interval)
            INTERVAL="$2"
            shift 2
            ;;
        -b|--battery)
            BATTERY_PATH="$2"
            shift 2
            ;;
        -t|--time)
            MAX_TIME="$2"
            shift 2
            ;;
        --no-interface)
            DISPLAY_INTERFACE=0
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            ;;
    esac
done

# Ensure the battery path is valid
if [ ! -d "$BATTERY_PATH" ]; then
    echo "Error: Battery path '$BATTERY_PATH' not found!"
    exit 1
fi

# Ensure the log file exists and has a header
if [ ! -f "$LOG_FILE" ]; then
    echo "Timestamp,Current (µA),Voltage (µV),Capacity (%),Charge (µAh),Temperature (°C),Charging" > "$LOG_FILE"
fi

# Function to fetch values and append to log file
log_battery_status() {
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    CURRENT=$(cat "$BATTERY_PATH/current_now" 2>/dev/null || echo "N/A")
    VOLTAGE=$(cat "$BATTERY_PATH/voltage_now" 2>/dev/null || echo "N/A")
    CAPACITY=$(cat "$BATTERY_PATH/capacity" 2>/dev/null || echo "N/A")
    CHARGE=$(cat "$BATTERY_PATH/charge_now" 2>/dev/null || echo "N/A")

    # Fetch temperature using acpi -t
    if command -v acpi &>/dev/null; then
        TEMPERATURE=$(acpi -t | awk '{print $4}')
    else
        TEMPERATURE="N/A"
    fi

    # Determine charging status
    STATUS=$(cat "$BATTERY_PATH/status" 2>/dev/null || echo "Unknown")
    CHARGING=0
    if [ "$STATUS" == "Charging" ]; then
        CHARGING=1
    fi

    echo "$TIMESTAMP,$CURRENT,$VOLTAGE,$CAPACITY,$CHARGE,$TEMPERATURE,$CHARGING" >> "$LOG_FILE"
}

# Function to display the terminal interface with cleaner formatting
show_terminal_interface() {
    clear
    echo "========================= BATTERY LOGGER ========================="
    echo "Log File: $LOG_FILE"
    echo "Interval: $INTERVAL seconds"
    echo "Battery Path: $BATTERY_PATH"
    echo "Start Time: $(date -d @$START_TIME)"
    echo "=================================================================="
    echo "Current Log File Size: $(du -h "$LOG_FILE" | cut -f1)"
    echo
    echo "======================== Current Battery Data ====================="
    echo "current_now      : $CURRENT µA"
    echo "charge_now       : $CHARGE µAh"
    echo "capacity         : $CAPACITY %"
    echo "voltage_now      : $VOLTAGE µV"
    echo "temperature      : $TEMPERATURE °C"
    echo "charging status  : $STATUS"
    echo "=================================================================="
}

# Track runtime
START_TIME=$(date +%s)

# Periodic logging
while true; do
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    # Exit if the maximum runtime is reached (if MAX_TIME > 0)
    if (( MAX_TIME > 0 && ELAPSED_TIME >= MAX_TIME )); then
        echo "Reached maximum runtime of $MAX_TIME seconds. Exiting."
        exit 0
    fi

    # Log battery status
    log_battery_status

    # Display the terminal interface if enabled
    if (( DISPLAY_INTERFACE )); then
        show_terminal_interface
    fi

    # Sleep for the specified interval
    sleep "$INTERVAL"
done