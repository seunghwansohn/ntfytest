#!/bin/bash
# Cryptographic functions for message-hub
# Source this file in other scripts

set -euo pipefail

# Generate encrypted topic name from passphrase and salt
get_encrypted_topic() {
    local topic_name="${1:-}"
    # Use -r or cut to get only the hash regardless of format
    echo -n "${topic_name}${TOPIC_PASSPHRASE}${SALT}" | openssl dgst -sha256 2>/dev/null | sed 's/.*= //' | sed 's/^.* //'
}

# Encrypt a message using AES-256-CBC
encrypt_msg() {
    local msg="$1"
    echo -n "$msg" | openssl enc -aes-256-cbc -A -a -salt -pass pass:"${MSG_PASSPHRASE}" 2>/dev/null
}

# Decrypt a message using AES-256-CBC
decrypt_msg() {
    local encrypted="$1"
    echo -n "$encrypted" | openssl enc -d -aes-256-cbc -A -a -pass pass:"${MSG_PASSPHRASE}" 2>/dev/null
}
