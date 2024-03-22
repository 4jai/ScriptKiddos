#!/bin/bash

# Function to install Elasticsearch
install_elasticsearch() {
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
}

# Function to install Kibana
install_kibana() {
    # Import Kibana GPG key
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/kibana-keyring.gpg

    # Install apt-transport-https if not installed
    sudo apt-get install -y apt-transport-https

    # Add Kibana repository to sources list
    echo "deb [signed-by=/usr/share/keyrings/kibana-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/kibana-8.x.list

    # Update package index and install Kibana
    sudo apt-get update && sudo apt-get install -y kibana

    # Start Kibana service
    sudo systemctl start kibana

    # Enable Kibana to start on system boot
    sudo systemctl enable kibana

    # Output status message
    echo "Kibana has been installed and started successfully."
}

# Function to install Logstash
install_logstash() {
    # Import Logstash GPG key
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/logstash-keyring.gpg

    # Install apt-transport-https if not installed
    sudo apt-get install -y apt-transport-https

    # Add Logstash repository to sources list
    echo "deb [signed-by=/usr/share/keyrings/logstash-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/logstash-8.x.list

    # Update package index and install Logstash
    sudo apt-get update && sudo apt-get install -y logstash

    # Output status message
    echo "Logstash has been installed successfully."
}

# Main script
echo "Select components to install:"
echo "1. Elasticsearch"
echo "2. Kibana"
echo "3. Logstash"
echo "Enter comma-separated numbers (e.g., 1,2,3): "
read components

IFS=',' read -ra component_arr <<< "$components"
for component in "${component_arr[@]}"; do
    case $component in
        1) install_elasticsearch ;;
        2) install_kibana ;;
        3) install_logstash ;;
        *) echo "Invalid option: $component" ;;
    esac
done
