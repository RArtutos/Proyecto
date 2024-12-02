#!/bin/bash

# Source configuration
source ./config.sh

# Function to check if a package is installed
check_package() {
    dpkg -l "$1" &> /dev/null
}

# Install required packages
echo "Installing required packages..."
PACKAGES="mysql-server python3-pip dialog openssl netcat"
for pkg in $PACKAGES; do
    if ! check_package "$pkg"; then
        sudo apt-get install -y "$pkg"
    fi
done

# Install Python packages
pip3 install mysql-connector-python cryptography python-dialog

# Create necessary directories
echo "Creating directories..."
sudo mkdir -p "$KEY_STORE_PATH" "$FILE_PATH" "$LOG_PATH"
sudo chmod 755 /var/lib/secure-files
sudo chmod 700 "$KEY_STORE_PATH"

# Configure MySQL
echo "Configuring MySQL..."
sudo mysql_secure_installation

# Create database and user
echo "Setting up database..."
sudo mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
sudo mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Set up cron job for synchronization
(crontab -l 2>/dev/null; echo "*/5 * * * * $PWD/src/sync/sync_tasks.sh") | crontab -

# Make scripts executable
chmod +x main.sh
chmod +x src/http/server.sh
chmod +x src/gui/main_menu.sh
chmod +x src/sync/sync_tasks.sh

echo "Setup completed successfully!"