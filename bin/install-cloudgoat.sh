#!/usr/bin/env bash

set -euo pipefail

echo "==> Provisioning CloudGoat Deployment Workspace..."

REPO_ROOT="$(pwd)"

# Install git-remote-codecommit
pip3 install --break-system-packages git-remote-codecommit

# Clone CloudGoat into labs directory
mkdir -p "$REPO_ROOT/labs"

if [ ! -d "$REPO_ROOT/labs/cloudgoat" ]; then
    git clone https://github.com/RhinoSecurityLabs/cloudgoat.git "$REPO_ROOT/labs/cloudgoat"
fi

cd "$REPO_ROOT/labs/cloudgoat"

# Create Python virtual environment
python3 -m venv .venv

source .venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

chmod +x cloudgoat.py

# Add aliases
echo "alias cg='$REPO_ROOT/labs/cloudgoat/cloudgoat.py'" >> ~/.bashrc
echo "alias cg-list='$REPO_ROOT/labs/cloudgoat/cloudgoat.py list'" >> ~/.bashrc
echo "alias cg-create='$REPO_ROOT/labs/cloudgoat/cloudgoat.py create'" >> ~/.bashrc
echo "alias cg-destroy='$REPO_ROOT/labs/cloudgoat/cloudgoat.py destroy'" >> ~/.bashrc

echo "==> CloudGoat installation complete."
