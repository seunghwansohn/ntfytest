#!/bin/bash
# Publish encrypted message to ntfy.sh
# Usage: ./publish.sh "message content" [topic_name]

set -euo pipefail

# Load environment
if [[ ! -f "$(dirname "$0")/../.env" ]]; then
    echo "[publish.sh] ERROR: .env file not found" >&2
    exit 1
fi
source "$(dirname "$0")/../.env"

# Load crypto functions
source "$(dirname "$0")/crypto.sh"

# Get parameters
MSG="${1:-}"
TOPIC_NAME="${2:-}"

if [[ -z "$MSG" ]]; then
    echo "[publish.sh] ERROR: No message provided" >&2
    exit 1
fi

# Get encrypted topic and encrypt message
ENCRYPTED_TOPIC=$(get_encrypted_topic "$TOPIC_NAME")
ENCRYPTED_MSG=$(encrypt_msg "$MSG")

# Publish to ntfy.sh
RESPONSE=$(curl -s -X POST \
    -H "Content-Type: text/plain" \
    -d "$ENCRYPTED_MSG" \
    "https://ntfy.sh/${ENCRYPTED_TOPIC}")

# Extract message ID from response
MSG_ID=$(echo "$RESPONSE" | jq -r '.id // empty' 2>/dev/null || echo "unknown")

echo "[publish.sh] Published. Message ID: $MSG_ID"
