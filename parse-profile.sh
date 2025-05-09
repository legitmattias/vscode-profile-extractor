#!/bin/bash

# Path to the .code-profile file
PROFILE_FILE="$1"  # Pass the file as an argument
DEBUG_MODE=false    # Default to not showing debug info

# Function to display usage/help
usage() {
  echo "Usage: $0 <profile-file> [--debug]"
  echo "  --debug    Show full debug information (unescaped JSON and more details)"
}

# Check if the file exists
if [ ! -f "$PROFILE_FILE" ]; then
  echo "File not found: $PROFILE_FILE"
  exit 1
fi

# Check for --debug flag
if [[ "$2" == "--debug" ]]; then
  DEBUG_MODE=true
fi

# Extract and display basic profile metadata (name, icon)
echo "Profile Metadata:"
PROFILE_NAME=$(jq -r '.name' "$PROFILE_FILE")
PROFILE_ICON=$(jq -r '.icon' "$PROFILE_FILE")

echo "Profile Name: $PROFILE_NAME"
echo "Profile Icon: $PROFILE_ICON"
echo ""

# Extract the extensions field (unescape the string to valid JSON)
EXTENSIONS_JSON=$(jq -r '.extensions' "$PROFILE_FILE")

# Unescape the extensions JSON to make it valid JSON
UNESCAPED_EXTENSIONS=$(echo "$EXTENSIONS_JSON" | sed 's/\\"/"/g')

# Parse the unescaped extensions JSON
echo "Installed Extensions:"
echo "$UNESCAPED_EXTENSIONS" | jq -r 'map("ID: \(.identifier.id), Name: \(.displayName // "No Display Name"), UUID: \(.identifier.uuid)") | .[]'

# Show debug info if --debug flag is set
if [ "$DEBUG_MODE" = true ]; then
  echo ""
  echo "Full Metadata Extract (for debugging):"
  jq . "$PROFILE_FILE"
fi

