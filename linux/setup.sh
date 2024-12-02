#!/bin/bash

# Install required packages
sudo apt-get update
sudo apt-get install -y \
    python3-pip \
    mysql-server \
    python3-cryptography \
    dialog

# Install Python dependencies
pip3 install \
    mysql-connector-python \
    cryptography \
    python-dialog

# Create necessary directories
sudo mkdir -p /var/lib/secure-files/{keys,files,logs}
sudo chmod 755 /var/lib/secure-files
sudo chmod 700 /var/lib/secure-files/keys

# Initialize MySQL
sudo mysql_secure_installation

# Create database and user
sudo mysql -e "CREATE DATABASE IF NOT EXISTS secure_files;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'secure_files'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON secure_files.* TO 'secure_files'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Initialize database tables
python3 src/database/db_manager.py

# Set up cron job for synchronization
(crontab -l 2>/dev/null; echo "*/5 * * * * python3 /usr/local/bin/secure-files/sync_users.py") | crontab -

# Start HTTP server
python3 src/http/server.py &

echo "Setup completed successfully!"