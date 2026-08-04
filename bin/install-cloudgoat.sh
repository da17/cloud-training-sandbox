#!/usr/bin/env bash

set -euo pipefail

echo "==> Provisioning CloudGoat Deployment Workspace..."

REPO_ROOT="$(pwd)"

# Install git-remote-codecommit
pip3 install --break-system-packages git-remote-codecommit

# Clone CloudGoat
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

# Install CloudGoat from pyproject.toml
pip install --upgrade pip
pip install .

# Add CloudGoat command aliases
cat <<EOF >> ~/.bashrc

# CloudGoat aliases
alias cg='cd $REPO_ROOT/labs/cloudgoat && source .venv/bin/activate && cloudgoat'
alias cg-list='cd $REPO_ROOT/labs/cloudgoat && source .venv/bin/activate && cloudgoat list'
alias cg-create='cd $REPO_ROOT/labs/cloudgoat && source .venv/bin/activate && cloudgoat create'
alias cg-destroy='cd $REPO_ROOT/labs/cloudgoat && source .venv/bin/activate && cloudgoat destroy'
EOF

echo "==> CloudGoat installation complete."
