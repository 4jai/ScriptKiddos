#!/bin/bash

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Import Elasticsearch GPG key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

# Install apt-transport-https if not installed
sudo apt-get install -y apt-transport-https

# Add Elasticsearch repository to sources list
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

# Update package index and install Elasticsearch
sudo apt-get update && sudo apt-get install -y elasticsearch

# Start Elasticsearch service
sudo systemctl start elasticsearch

# Enable Elasticsearch to start on system boot
sudo systemctl enable elasticsearch

# Output status message
echo "Elasticsearch has been installed and started successfully."
