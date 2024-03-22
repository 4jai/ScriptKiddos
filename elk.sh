#!/bin/bash

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Import Elasticsearch GPG key if not already imported
if [ ! -f /usr/share/keyrings/elasticsearch-keyring.gpg ]; then
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
fi

# Install apt-transport-https if not installed
sudo apt-get install -y apt-transport-https

# Add Elasticsearch repository to sources list if not already added
if ! grep -q "artifacts.elastic.co/packages/8.x/apt" /etc/apt/sources.list.d/elastic-8.x.list; then
    echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
fi

# Update package index
sudo apt-get update

# Function to install Elasticsearch
install_elasticsearch() {
    sudo apt-get install -y elasticsearch
    sudo systemctl start elasticsearch
    sudo systemctl enable elasticsearch
    echo "Elasticsearch has been installed and started successfully."
}

# Function to install Kibana
install_kibana() {
    sudo apt-get install -y kibana
    sudo systemctl start kibana
    sudo systemctl enable kibana
    echo "Kibana has been installed and started successfully."
}

# Function to install Logstash
install_logstash() {
    sudo apt-get install -y logstash
    echo "Logstash has been installed successfully."
}

# Prompt user for installation choice
echo "Which component do you want to install?"
echo "1. Elasticsearch"
echo "2. Kibana"
echo "3. Logstash"
read -p "Enter your choice (1, 2, or 3): " choice

# Execute installation based on user choice
case $choice in
    1) install_elasticsearch ;;
    2) install_kibana ;;
    3) install_logstash ;;
    *) echo "Invalid choice. Exiting." ;;
esac
