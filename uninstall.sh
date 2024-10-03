#!/bin/bash

SERVICE_NAME="discord-update-helper.service"
INSTALL_PATH="/usr/local/bin/discord-update-helper.sh"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME"

echo "Stopping and disabling the service..."
sudo systemctl stop "$SERVICE_NAME"
sudo systemctl disable "$SERVICE_NAME"

echo "Removing the service file..."
sudo rm "$SERVICE_PATH"

echo "Removing the script..."
sudo rm "$INSTALL_PATH"

echo "Reloading systemd..."
sudo systemctl daemon-reload

echo "Service uninstalled successfully."
