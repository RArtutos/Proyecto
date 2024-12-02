#!/bin/bash

# Main entry point for Linux application

# Source configuration
source ./config.sh

# Source required modules
source ./src/database/db_manager.sh
source ./src/gui/main_menu.sh
source ./src/process/process_manager.sh

# Initialize database
initialize_database

# Start HTTP server in background
./src/http/server.sh &

# Start main menu
show_main_menu