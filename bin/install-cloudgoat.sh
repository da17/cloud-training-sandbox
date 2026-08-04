#!/usr/bin/env bash

set -euo pipefail

echo "==> Provisioning CloudGoat Deployment Workspace..."

REPO_ROOT="$(pwd)"

# Install git-remote-codecommit
pip3 install --break-system-packages git-remote-codecommit

# Clone CloudGoat if it does not already exist
mkdir -p "$REPO_ROOT/labs"

if [ ! -d "$REPO_ROOT/labs/cloudgoat" ]; then
    git clone https://github.com/RhinoSecurityLabs/cloudgoat.git "$REPO_ROOT/labs/cloudgoat"
fi

cd "$REPO_ROOT/labs/cloudgoat"

# Create Python virtual environment
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

source .venv/bin/activate

# Install CloudGoat from the current package definition
pip install --upgrade pip
pip install .

# Ensure CloudGoat launcher is executable
chmod +x cloudgoat/cloudgoat.py

# Add terminal shortcuts
cat <<EOF >> ~/.bashrc

# CloudGoat aliases
alias cg='source $REPO_ROOT/labs/cloudgoat/.venv/bin/activate && python $REPO_ROOT/labs/cloudgoat/cloudgoat/cloudgoat.py'
alias cg-list='source $REPO_ROOT/labs/cloudgoat/.venv/bin/activate && python $REPO_ROOT/labs/cloudgoat/cloudgoat/cloudgoat.py list'
alias cg-create='source $REPO_ROOT/labs/cloudgoat/.venv/bin/activate && python $REPO_ROOT/labs/cloudgoat/cloudgoat/cloudgoat.py create'
alias cg-destroy='source $REPO_ROOT/labs/cloudgoat/.venv/bin/activate && python $REPO_ROOT/labs/cloudgoat/cloudgoat/cloudgoat.py destroy'
EOF

echo "==> CloudGoat installation complete."
