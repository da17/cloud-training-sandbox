#!/usr/bin/env bash
echo "==> Provisioning CloudGoat Deployment Workspace..."
pip3 install git-remote-codecommit --break-system-packages 2>/dev/null || pip3 install git-remote-codecommit
git clone https://github.com $GITPOD_REPO_ROOT/labs/cloudgoat
cd $GITPOD_REPO_ROOT/labs/cloudgoat
pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
chmod +x cloudgoat.py

echo 'alias cg="./labs/cloudgoat/cloudgoat.py"' >> ~/.bashrc
