#!/bin/bash

### Updating the Server ###
echo "Updating the system..."
sudo apt-get update -y

### Installing Java ###
echo "Installing Java..."
sudo apt-get install openjdk-11-jdk -y

### Uninstalling Conflicting Docker Packages ###
echo "Removing conflicting Docker packages..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
    sudo apt-get remove -y $pkg
done

### Adding Docker's GPG Key and Repository ###
echo "Adding Docker’s GPG key and setting up repository..."
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

### Installing Docker ###
echo "Updating package list and installing Docker..."
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

### Adding Jenkins Repository ###
echo "Adding Jenkins repository and key..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

### Installing Jenkins ###
echo "Updating package list and installing Jenkins..."
sudo apt-get update -y
sudo apt-get install -y jenkins

### Starting and Enabling Services ###
echo "Starting and enabling Docker and Jenkins services..."
sudo systemctl enable --now docker
sudo systemctl enable --now jenkins

echo "Installation complete!"
