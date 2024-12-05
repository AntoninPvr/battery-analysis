#!/bin/bash

# Check if PROJECT_DIR is set
if [ -z "$PROJECT_DIR" ]; then
    echo "Error: PROJECT_DIR is not set. Please run set_project_dir.sh first."
    exit 1
fi

# Directories to purge files from
dirs=("analysis" "reports")

# Loop through each directory in PROJECT_DIR
for dir in "${dirs[@]}"; do
    # Full path to directory
    full_path="$PROJECT_DIR/$dir"

    # Check if the directory exists
    if [ -d "$full_path" ]; then
        # Find and remove all files except .gitkeep in the specified directories
        find "$full_path" -type f ! -name ".gitkeep" -exec rm -f {} \;
        echo "Purged files in $full_path"
    else
        echo "Directory $full_path does not exist. Skipping..."
    fi
done

echo "Purge complete: All files except .gitkeep have been removed."
