#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if a version bump type is provided
if [ -z "$1" ]; then
  echo "Usage: $0 [major|minor|patch]"
  exit 1
fi

# Read the current version from the VERSION file
if [ ! -f VERSION ]; then
  echo "0.0.0" > VERSION
fi
current_version=$(cat VERSION)

# Split the version into major, minor, and patch components
IFS='.' read -r major minor patch <<< "${current_version#v}"

# Increment the version based on the bump type
case "$1" in
  major)
    major=$((major + 1))
    minor=0
    patch=0
    ;;
  minor)
    minor=$((minor + 1))
    patch=0
    ;;
  patch)
    patch=$((patch + 1))
    ;;
  *)
    echo "Invalid bump type: $1. Use major, minor, or patch."
    exit 1
    ;;
esac

# Construct the new version
new_version="v$major.$minor.$patch"

# Write the new version to the VERSION file
echo "$new_version" > VERSION

echo "Version bumped to $new_version"
