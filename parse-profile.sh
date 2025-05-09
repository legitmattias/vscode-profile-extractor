#!/bin/bash

# Path to the .code-profile file
PROFILE_FILE="$1"  # Pass the file as an argument
DEBUG_MODE=false    # Default to not showing debug info
VERBOSE_MODE=false  # Default to not showing verbose output

# Function to display usage/help
usage() {
  echo "Usage: $0 <profile-file> [--verbose] [--debug]"
  echo "  --verbose  Show extended extension details (ID, UUID)"
  echo "  --debug    Show full debug information (unescaped JSON and more details)"
}

# Check if the file exists
if [ ! -f "$PROFILE_FILE" ]; then
  echo "File not found: $PROFILE_FILE"
  exit 1
fi

# Check for --verbose and --debug flags
if [[ "$2" == "--verbose" ]]; then
  VERBOSE_MODE=true
elif [[ "$2" == "--debug" ]]; then
  DEBUG_MODE=true
elif [[ "$2" == "--verbose" && "$3" == "--debug" ]]; then
  VERBOSE_MODE=true
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

# Show installed extensions (default behavior shows only the names)
echo "Installed Extensions:"
if [ "$VERBOSE_MODE" = true ]; then
  # Verbose output: Show ID, Name, and UUID for each extension
  echo "$UNESCAPED_EXTENSIONS" | jq -r 'map("ID: \(.identifier.id), Name: \(.displayName // "No Display Name"), UUID: \(.identifier.uuid)") | .[]'
else
  # Default output: Show only the display name of each extension
  echo "$UNESCAPED_EXTENSIONS" | jq -r 'map(.displayName // "No Display Name") | .[]'
fi

# Show debug info if --debug flag is set
if [ "$DEBUG_MODE" = true ]; then
  echo ""
  echo "Full Metadata Extract (for debugging):"
  jq . "$PROFILE_FILE"
fi

