#!/bin/bash

function install_docker() {
  # Step 1: Update and install dependencies
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl gnupg lsb-release

  # Step 2: Add Docker repository
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update

  # Step 3: Install Docker
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

  # Step 4: Ask user if they want to test Docker installation
  read -p "Do you want to test Docker installation? (y/n): " test_docker
  if [ "$test_docker" == "y" ]; then
    sudo docker run hello-world
  fi

  # Step 5: Ask user if they want to enable Docker in startup
  read -p "Do you want to enable Docker in startup? (y/n): " enable_startup
  if [ "$enable_startup" == "y" ]; then
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
  fi

  # Step 6: Ask user if they want to add Docker groups to current user
  read -p "Do you want to add Docker groups to the current user? (y/n): " add_docker_groups
  if [ "$add_docker_groups" == "y" ]; then
    sudo groupadd docker
    sudo usermod -aG docker $USER
    echo "Please log out and log back in to apply group changes."
  fi

  echo "Docker installation script completed."
}

function uninstall_docker() {
  # Step 1: Remove Docker
  sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

  # Step 2: Remove Docker repository
  sudo rm -rf /etc/apt/keyrings/docker.gpg
  sudo rm -f /etc/apt/sources.list.d/docker.list

  # Step 3: Remove Docker groups
  read -p "Do you want to remove Docker groups from the current user? (y/n): " remove_docker_groups
  if [ "$remove_docker_groups" == "y" ]; then
    sudo deluser $USER docker
    sudo groupdel docker
  fi

  # Step 4: Remove Docker configurations
  read -p "Do you want to remove Docker configurations and images? (y/n): " remove_docker_configs
  if [ "$remove_docker_configs" == "y" ]; then
    sudo rm -rf /var/lib/docker
  fi

  # Step 5: Disable Docker in startup
  read -p "Do you want to disable Docker in startup? (y/n): " disable_startup
  if [ "$disable_startup" == "y" ]; then
    sudo systemctl disable docker.service
    sudo systemctl disable containerd.service
  fi

  echo "Docker uninstallation script completed."
}

function check_docker() {
  sudo docker run hello-world
}

echo "Docker Installation and Uninstallation Script"

while true; do
  echo "Select an option:"
  echo "1. Install Docker"
  echo "2. Uninstall Docker"
  echo "3. Check if Docker is installed correctly"
  echo "4. Quit"

  read -p "Enter your choice (1/2/3/4): " choice

  case $choice in
    1)
      install_docker
      ;;
    2)
      read -p "Are you sure you want to uninstall Docker? This will remove all Docker configurations. (y/n): " confirm_uninstall
      if [ "$confirm_uninstall" == "y" ]; then
        uninstall_docker
      else
        echo "Uninstallation aborted."
      fi
      ;;
    3)
      check_docker
      ;;
    4)
      echo "Exiting script."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please enter a valid option (1/2/3/4)."
      ;;
  esac
done
