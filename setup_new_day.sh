#!/bin/bash

# Usage: ./setup_new_day.sh

# Get today's day number
today=$(date +"%d")

# Convert day to integer
day_number=$((10#$today))

# Check if day is above 25
if [ "$day_number" -gt 25 ]; then
  echo "The event is over! Hope you had a great time solving the puzzles. Now it's time to relax and enjoy the holiday season! 🎉"
  exit 0
fi

# Ensure the day is two digits
DAY=$(printf "%02d" $day_number)

# Create a new day folder
TARGET_DIR="./$DAY"
mkdir -p "$TARGET_DIR"

# Call download_input.sh script with the correct day number
./download_input.sh "$day_number"
