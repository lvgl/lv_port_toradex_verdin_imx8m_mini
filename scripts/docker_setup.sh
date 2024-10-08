#!/bin/bash

# Get the directory of the current script and move to the parent directory 
# where Dockerfile is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

# Check if the correct argument is passed
if [[ "$1" == "--create-image" ]]; then
    echo "Building the Docker container..."
    docker build --platform linux/arm64/v8 -t lvgl-build-arm64-image . 

elif [[ "$1" == "--build-app" ]]; then
    echo "Running the Docker container..."
    docker run --rm --platform linux/arm64/v8 -v $(pwd):/app lvgl-build-arm64-image

else
    echo "Usage: $0 --create-image or --build-app"
    exit 1
fi
