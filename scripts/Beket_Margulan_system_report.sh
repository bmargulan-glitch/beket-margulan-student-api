#!/bin/bash
# Task 1.2 — System monitoring script
# Author: Beket Margulan (it2-2302, ID 38109)
# Works on Linux and macOS. Output goes to the screen AND to the personal log.

STUDENT_NAME="Beket Margulan"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../logs/Beket_Margulan_system_report.log"

mkdir -p "$(dirname "$LOG_FILE")"

report() {
    echo "=================================================="
    echo " SYSTEM REPORT"
    echo "=================================================="
    echo "Student:       $STUDENT_NAME"
    echo "Date and time: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Username:      $(whoami)"
    echo

    echo "--- Operating system and kernel ---"
    if [ "$(uname -s)" = "Darwin" ]; then
        echo "OS:     $(sw_vers -productName) $(sw_vers -productVersion)"
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "OS:     $PRETTY_NAME"
    else
        echo "OS:     $(uname -s)"
    fi
    echo "Kernel: $(uname -sr)"
    echo

    echo "--- CPU ---"
    if [ "$(uname -s)" = "Darwin" ]; then
        echo "Model: $(sysctl -n machdep.cpu.brand_string)"
        echo "Cores: $(sysctl -n hw.ncpu)"
    else
        grep -m1 "model name" /proc/cpuinfo | sed 's/.*: /Model: /'
        echo "Cores: $(nproc)"
    fi
    echo

    echo "--- Memory ---"
    if [ "$(uname -s)" = "Darwin" ]; then
        echo "Total RAM: $(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 )) GB"
        vm_stat | head -6
    else
        free -h
    fi
    echo

    echo "--- Disk usage ---"
    df -h
    echo

    echo "--- Available space on / ---"
    df -h / | awk 'NR==2 {print "Available: " $4 " of " $2 " (used " $5 ")"}'
    echo "=================================================="
    echo
}

# tee -a: show on screen and APPEND to the log
report | tee -a "$LOG_FILE"
echo "Report saved to $LOG_FILE"
