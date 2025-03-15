#!/bin/bash

# Define the source and destination file paths
SOURCE_SCRIPT="llm.sh"
DESTINATION="/usr/local/bin/llm"

# Check if the source script exists
if [ ! -f "$SOURCE_SCRIPT" ]; then
  echo "Error: $SOURCE_SCRIPT does not exist."
  exit 1
fi

# Make sure /usr/local/bin exists and is writable
if [ ! -w "/usr/local/bin" ]; then
  echo "Error: /usr/local/bin is not writable. Please run the script with sudo."
  exit 1
fi

# Copy the script to /usr/local/bin and remove the .sh extension
cp "$SOURCE_SCRIPT" "$DESTINATION"

# Make the copied script executable
chmod +x "$DESTINATION"

# Verify if the script is successfully copied and made executable
if [ $? -eq 0 ]; then
  echo "A copy of the script was successfully placed in /usr/local/bin as 'llm'."
else
  echo "Error: Failed to copy the script to /usr/local/bin."
  exit 1
fi
