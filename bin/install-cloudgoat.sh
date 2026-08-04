#!/usr/bin/env bash

set -euo pipefail

echo "==> Provisioning CloudGoat Deployment Workspace..."

REPO_ROOT="$(pwd)"

# Install git-remote-codecommit (system utility)
pip3 install --break-system-packages git-remote-codecommit

# Clone CloudGoat if it doesn't already exist
mkdir -p "$REPO_ROOT/labs"

if [ ! -d "$REPO_ROOT/labs/cloudgoat" ]; then
    git clone https://github.com/RhinoSecurityLabs/cloudgoat.git "$REPO_ROOT/labs/cloudgoat"
fi

cd "$REPO_ROOT/labs/cloudgoat"

# Create and activate a virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Upgrade pip and install CloudGoat
pip install --upgrade pip
pip install .

chmod +x cloudgoat.py

# Add aliases (using the virtual environment's Python)
echo "alias cg='source $REPO_ROOT/labs/cloudgoat/.venv/bin/activate && python $REPO_ROOT/labs/cloudgoat/cloudgoat.py'" >> ~/.bashrc
echo "alias cg-list='source $REPO_ROOT/labs/cloudgoat/.venv/bin/activate && python $REPO_ROOT/labs/cloudgoat/cloudgoat.py list'" >> ~/.bashrc
echo "alias cg-create='source $REPO_ROOT/labs/cloudgoat/.venv/bin/activate && python $REPO_ROOT/labs/cloudgoat/cloudgoat.py create'" >> ~/.bashrc
echo "alias cg-destroy='source $REPO_ROOT/labs/cloudgoat/.venv/bin/activate && python $REPO_ROOT/labs/cloudgoat/cloudgoat.py destroy'" >> ~/.bashrc

echo "==> CloudGoat installation complete."
