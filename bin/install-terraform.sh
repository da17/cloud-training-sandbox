#!/usr/bin/env bash
echo "==> Upgrading system packages and installing Terraform..."
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl unzip python3-pip python3-venv
wget -O- https://hashicorp.com | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://hashicorp.com jammy main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
