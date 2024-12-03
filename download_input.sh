#!/bin/bash

# Usage: ./download_input.sh <day_number>

# Load environment variables from .env file if it exists
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Check if the session cookie is set
if [ -z "$SESSION_COOKIE" ]; then
  echo "Error: SESSION_COOKIE is not set. Please set it in the .env file."
  exit 1
fi

# Check if the day number is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <day_number>"
  exit 1
fi

# Ensure the day is two digits
DAY=$(printf "%02d" $1)

# Set the URL
URL="https://adventofcode.com/2024/day/$1/input"

# Set the target folder
TARGET_DIR="./$DAY"

# Create the folder if it doesn't exist
mkdir -p "$TARGET_DIR"

# Download the input file into the appropriate folder
curl -s -H "Cookie: session=$SESSION_COOKIE" "$URL" -o "$TARGET_DIR/input.txt"

# Check if download was successful
if [ $? -eq 0 ]; then
  echo "Input for day $DAY downloaded successfully to $TARGET_DIR/input.txt"
else
  echo "Failed to download input for day $DAY"
fi
