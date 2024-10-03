#!/bin/bash

# build_info path (arch)
FILE_PATH="/opt/discord/resources"

BUILD_INFO="$FILE_PATH/build_info.json"

if [[ ! -f "$BUILD_INFO" ]]; then
  echo "Error: File $BUILD_INFO"
  exit 1
fi

vnr_local=$(jq -r '.version' "$BUILD_INFO")
BRANCH=$(jq -r '.releaseChannel' "$BUILD_INFO")

API_URL="https://discord.com/api/updates/$BRANCH?platform=linux"

response=$(curl -s $API_URL)

if [[ $? -ne 0 ]]; then
  echo "Error: Not able to fetch data from the API"
  exit 1
fi

vnr_latest=$(echo $response | jq -r '.name')

if [[ $? -ne 0 ]]; then
  echo "Error: Failed to parse JSON"
  exit 1
fi

if [[ "$vnr_latest" != "$vnr_local" ]]; then
  echo "Versions don't match, updating the version in $BUILD_INFO"
  cp $BUILD_INFO "$FILE_PATH/build_info.bak"
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create backup of build_info.json"
    exit 1
  fi

  sudo jq --arg new_version "$vnr_latest" '.version = $new_version' "$BUILD_INFO" >"$BUILD_INFO.tmp" &&
    if [[ $? -ne 0 ]]; then
      echo "Error: Failed to write new version to temporary file"
      exit 1
    fi

  sudo mv "$BUILD_INFO.tmp" "$BUILD_INFO"
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to move temporary file to $BUILD_INFO"
    exit 1
  fi

  echo "Updated build_info.json with version: $vnr_latest"
else
  echo "Version numbers match. No update needed."
fi
