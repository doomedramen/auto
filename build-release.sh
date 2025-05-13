#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the platforms and architectures to build for
PLATFORMS=("linux" "darwin" "windows")
ARCHITECTURES=("amd64" "arm64")

# Create a directory for the release binaries
mkdir -p release

# Build for each platform and architecture
for platform in "${PLATFORMS[@]}"; do
  for arch in "${ARCHITECTURES[@]}"; do
    output_dir="release/${platform}-${arch}"
    mkdir -p "$output_dir"

    output_name="auto"
    if [ "$platform" == "windows" ]; then
      output_name+=".exe"
    fi

    echo "Building for $platform/$arch..."
    GOOS=$platform GOARCH=$arch go build -o "$output_dir/$output_name"
  done
done

# Print completion message
echo "Builds completed. Binaries are organized in the 'release' directory by platform and architecture."
