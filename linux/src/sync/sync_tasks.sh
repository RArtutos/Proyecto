#!/bin/bash

# Sync tasks configuration
SYNC_INTERVAL=300  # 5 minutes in seconds
WINDOWS_SERVER="http://localhost:8080"
LOG_FILE="/var/lib/secure-files/logs/sync.log"

function log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

function sync_users() {
    log_message "Starting user synchronization"
    curl -s "$WINDOWS_SERVER/api/users" | \
    while read -r user; do
        if ! grep -q "^$user:" /etc/passwd; then
            useradd -m "$user"
            log_message "Added user: $user"
        fi
    done
}

function sync_files() {
    log_message "Starting file synchronization"
    curl -s "$WINDOWS_SERVER/api/files" | \
    while read -r file; do
        if [ ! -f "/var/lib/secure-files/files/$file" ]; then
            curl -s "$WINDOWS_SERVER/api/files/$file" -o "/var/lib/secure-files/files/$file"
            log_message "Downloaded file: $file"
        fi
    done
}

# Main sync loop
while true; do
    sync_users
    sync_files
    sleep "$SYNC_INTERVAL"
done