#!/bin/bash

SERVICE_NAME="discord-update-helper.service"
SCRIPT_NAME="discord-update-helper.sh"
INSTALL_PATH="/usr/local/bin"
SERVICE_PATH="/etc/systemd/system"

if [[ ! -f "./$SCRIPT_NAME" ]]; then
  echo "Error: $SCRIPT_NAME not found in the current directory."
  exit 1
fi

# Copy the script to /usr/local/bin for global access
echo "Copying script to $INSTALL_PATH..."
sudo cp "./$SCRIPT_NAME" "$INSTALL_PATH/$SCRIPT_NAME"
sudo chmod +x "$INSTALL_PATH/$SCRIPT_NAME"

echo "Creating the systemd service file..."

sudo bash -c "cat > $SERVICE_PATH/$SERVICE_NAME" <<EOL
[Unit]
Description=Discord Update Helper
After=network-online.target

[Service]
Type=oneshot
ExecStart=$INSTALL_PATH/$SCRIPT_NAME

[Install]
WantedBy=multi-user.target
EOL

sudo chmod 644 "$SERVICE_PATH/$SERVICE_NAME"

# Reload systemd to recognize the new service
echo "Reloading systemd..."
sudo systemctl daemon-reload

echo "Enabling and starting the service..."
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"

echo "Service $SERVICE_NAME installed and started successfully."
