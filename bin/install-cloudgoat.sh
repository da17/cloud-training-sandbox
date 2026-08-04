#!/usr/bin/env bash
echo "==> Provisioning CloudGoat Deployment Workspace..."
pip3 install git-remote-codecommit --break-system-packages 2>/dev/null || pip3 install git-remote-codecommit
git clone https://github.com/RhinoSecurityLabs/cloudgoat.git \$GITPOD_REPO_ROOT/labs/cloudgoat
cd \$GITPOD_REPO_ROOT/labs/cloudgoat
pip3 install -r requirements.txt --break-system-packages 2>/dev/null || pip3 install -r requirements.txt
chmod +x cloudgoat.py

# Injecting shorthand ExamPro-style terminal macros directly into the terminal environment
echo 'alias cg="./labs/cloudgoat/cloudgoat.py"' >> ~/.bashrc
echo 'alias cg-list="./labs/cloudgoat/cloudgoat.py list"' >> ~/.bashrc
echo 'alias cg-create="./labs/cloudgoat/cloudgoat.py create"' >> ~/.bashrc
echo 'alias cg-destroy="./labs/cloudgoat/cloudgoat.py destroy"' >> ~/.bashrc