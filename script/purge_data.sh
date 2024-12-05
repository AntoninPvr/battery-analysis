#!/bin/bash

# Check if PROJECT_DIR is set
if [ -z "$PROJECT_DIR" ]; then
    echo "Error: PROJECT_DIR is not set. Please run setup.sh first."
    exit 1
fi

# Define the data directory path
data_dir="$PROJECT_DIR/data"

# Check if the data directory exists
if [ -d "$data_dir" ]; then
    # Find and remove all files except .gitkeep in the data directory
    find "$data_dir" -type f ! -name ".gitkeep" -exec rm -f {} \;
    echo "Purged files in $data_dir (excluding .gitkeep)"
else
    echo "Directory $data_dir does not exist. Skipping..."
fi

echo "Purge complete: All files in $data_dir."
