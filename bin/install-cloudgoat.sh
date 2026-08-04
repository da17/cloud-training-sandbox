#!/usr/bin/env bash

set -euo pipefail

echo "==> Provisioning CloudGoat Deployment Workspace..."

REPO_ROOT="$(pwd)"

# Install git-remote-codecommit
echo "==> Installing git-remote-codecommit..."
pip3 install --break-system-packages git-remote-codecommit

# Clone CloudGoat
mkdir -p "$REPO_ROOT/labs"

if [ ! -d "$REPO_ROOT/labs/cloudgoat" ]; then
    echo "==> Cloning CloudGoat..."
    git clone https://github.com/RhinoSecurityLabs/cloudgoat.git "$REPO_ROOT/labs/cloudgoat"
else
    echo "==> CloudGoat already exists, skipping clone..."
fi

cd "$REPO_ROOT/labs/cloudgoat"

# Create Python virtual environment if required
if [ ! -d ".venv" ]; then
    echo "==> Creating Python virtual environment..."
    python3 -m venv .venv
fi

source .venv/bin/activate

# Repair pip if the existing venv is incomplete
echo "==> Ensuring pip is available..."
python -m ensurepip --upgrade

echo "==> Upgrading pip..."
python -m pip install --upgrade pip

# Install CloudGoat package
echo "==> Installing CloudGoat..."
python -m pip install .

# Add aliases once
if ! grep -q "# CloudGoat aliases" ~/.bashrc; then
    cat <<EOF >> ~/.bashrc

# CloudGoat aliases
alias cg='cd $REPO_ROOT/labs/cloudgoat && source .venv/bin/activate && cloudgoat'
alias cg-list='cd $REPO_ROOT/labs/cloudgoat && source .venv/bin/activate && cloudgoat list'
alias cg-create='cd $REPO_ROOT/labs/cloudgoat && source .venv/bin/activate && cloudgoat create'
alias cg-destroy='cd $REPO_ROOT/labs/cloudgoat && source .venv/bin/activate && cloudgoat destroy'
EOF
fi

echo "==> CloudGoat installation complete."
echo "==> Run: source ~/.bashrc"
