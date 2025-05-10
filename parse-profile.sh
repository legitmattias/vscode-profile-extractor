#!/usr/bin/env bash

DEBUG_MODE=false    # Default to not showing debug info
VERBOSE_MODE=false  # Default to not showing verbose output

# Function to display usage/help
usage() {
  cat <<EOF
===================================
VS Code Profile Extension Extractor
===================================
This script parses a .code-profile file exported from Visual Studio Code
and lists the installed extensions. You can optionally display more
detailed metadata or debug information.

=========
HELP INFO
=========
Usage: $0 <profile-file> [--verbose] [--debug] [--help]
  --verbose  Show extended extension details (ID text descriptor, UUID)
  --debug    Show full debug information (unescaped JSON and more details)
  --help     Show this help message
EOF
}

# Ensure at least one argument is provided
if [ $# -eq 0 ]; then
  usage
  exit 1
fi

# Parse arguments and flags
PROFILE_FILE=""
for arg in "$@"; do
  case "$arg" in
    --verbose)
      VERBOSE_MODE=true
      ;;
    --debug)
      DEBUG_MODE=true
      ;;
    --help)
      usage
      exit 0
      ;;
    --*)
      echo "Unknown option: $arg"
      usage
      exit 1
      ;;
    *)
      if [ -z "$PROFILE_FILE" ]; then
        PROFILE_FILE="$arg"
      fi
      ;;
  esac
done

# Check if the file exists
if [ ! -f "$PROFILE_FILE" ]; then
  echo "File not found: $PROFILE_FILE"
  exit 1
fi

# Extract and display basic profile metadata (name, icon)
echo "Profile Metadata:"
echo "-----------------"

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
echo "---------------------"
if [ "$VERBOSE_MODE" = true ]; then
  # Verbose output: Show Name, ID, and UUID for each extension
  echo "$UNESCAPED_EXTENSIONS" | jq -r '
  map("Name: \(.displayName // "No Display Name")\n├─ ID: \(.identifier.id)\n└─ UUID: \(.identifier.uuid)") | .[]'
else
  # Default output: Show only the display name of each extension
  echo "$UNESCAPED_EXTENSIONS" | jq -r '
    map(
      if .displayName
      then .displayName
      else "No Display Name found. Identificational name: \(.identifier.id)"
      end
    ) | .[]'
fi

# Show debug info if --debug flag is set
if [ "$DEBUG_MODE" = true ]; then
  echo ""
  echo "Full Metadata Extract (for debugging):"
  jq . "$PROFILE_FILE"
fi

