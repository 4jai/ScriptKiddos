#!/bin/bash

# Step 1: Check permission
if [[ $EUID -ne 0 ]]; then
  echo "This script needs sudo. Please run with sudo."
  exit 1
fi

# Step 2: Update repo & install dependencies
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Step 3: Add PGP key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Step 4: Add docker repo
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 5: Update repo
sudo apt-get update

# Step 6: Install components
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

# Step 7: Ask user if they want to add docker groups to current user
read -p "Do you want to add your user to the docker group? (y/n): " add_to_docker_group
if [ "$add_to_docker_group" == "y" ]; then
  sudo usermod -aG docker $USER
  echo "User added to the docker group. Please log out and log back in for the changes to take effect."
fi

# Step 8: Ask user to enable docker on startup
read -p "Do you want to enable Docker on startup? (y/n): " enable_docker_startup
if [ "$enable_docker_startup" == "y" ]; then
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
  echo "Docker enabled on startup."
fi

# Step 9: Verify installation by running hello world
read -p "Do you want to verify the Docker installation by running hello-world? (y/n): " verify_installation
if [ "$verify_installation" == "y" ]; then
  sudo docker run hello-world
fi

echo "Docker installation script completed."
