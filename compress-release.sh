#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Navigate to the release directory
cd release

# Compress each platform-architecture folder into a .zip file
# Remove the platform-architecture folders after zipping them
for dir in */; do
  dir_name=$(basename "$dir")
  echo "Compressing $dir_name..."
  zip -r "$dir_name.zip" "$dir_name"
  # Remove the folder after zipping
  rm -rf "$dir_name"
done

# Navigate back to the root directory
cd ..

# Print completion message
echo "Compression completed. Zipped files are in the 'release' directory."
