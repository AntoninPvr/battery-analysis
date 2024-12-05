#!/bin/bash

# Define the project directory (you can modify this to point to your project folder)
PROJECT_DIR="$(pwd)"

# Export the environment variable
export PROJECT_DIR

# Confirm the environment variable has been set
echo "PROJECT_DIR is set to $PROJECT_DIR"

# Add an alias to run the clean script
alias clean="bash $PROJECT_DIR/script/clean_analysis.sh"
echo "Alias 'clean_analysis' has been set to run the clean script."

# Add an alias to run the purge script
alias purge="bash $PROJECT_DIR/script/purge_data.sh"
echo "Alias 'purge_data' has been set to run the purge script."
