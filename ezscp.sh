#!/bin/bash

# Prompting user for input
read -p "File path: " FILE_PATH
read -p "Username: " USERNAME
read -p "IP: " IP_ADDRESS
read -p "Path to transfer: " DEST_PATH
read -s -p "Password: " PASSWORD

# SCP transfer
scp "$FILE_PATH" "$USERNAME@$IP_ADDRESS:$DEST_PATH" << EOF
$PASSWORD
EOF

# Checking SCP exit status
if [ $? -eq 0 ]; then
    echo "File transferred successfully."
else
    echo "Error occurred during file transfer."
fi
