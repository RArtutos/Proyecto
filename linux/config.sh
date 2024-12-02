#!/bin/bash

# Database configuration
DB_HOST="localhost"
DB_NAME="secure_files"
DB_USER="secure_files"
DB_PASS="your_secure_password"

# File paths
KEY_STORE_PATH="/var/lib/secure-files/keys"
FILE_PATH="/var/lib/secure-files/files"
LOG_PATH="/var/lib/secure-files/logs"

# Server configuration
HTTP_PORT=8080
WINDOWS_SERVER="http://localhost:8080"

# Export all variables
export DB_HOST DB_NAME DB_USER DB_PASS
export KEY_STORE_PATH FILE_PATH LOG_PATH
export HTTP_PORT WINDOWS_SERVER