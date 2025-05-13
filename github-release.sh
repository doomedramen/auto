#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null
then
    echo "GitHub CLI (gh) is not installed. Please install it to proceed."
    exit 1
fi

# Define variables
RELEASE_DIR="release"

# Read the version from the VERSION file
VERSION=$(cat VERSION)

# Create a new GitHub release
echo "Creating GitHub release $VERSION..."
gh release create "$VERSION" "$RELEASE_DIR"/*.zip \
    --title "Release $VERSION" \
    --notes "Automated release for version $VERSION"

echo "GitHub release $VERSION created successfully."
