# Cloud Engineering & Security Training Sandbox

## 📁 Repository Directory Layout
Create this layout inside a folder named `cloud-training-sandbox` on your local Mac's Desktop:

```text
├── .gitignore                 # Excludes sensitive data and temporary state tracking files
├── .gitpod.yml                # Gitpod workspace lifecycle management orchestrator
├── README.md                  # Comprehensive setup guide and reference manual
├── bin/                       # Automation bash execution binaries
│   ├── install-terraform      # Packages HashiCorp core systems
│   ├── install-aws-cli        # Mounts Amazon Web Services interfaces
│   ├── install-azure-cli      # Attaches Microsoft Azure utilities
│   ├── install-cloudgoat      # Provisions target penetration labs and custom shortcuts
│   └── set-gitpod-variables   # Local Mac script to push AWS keys to Gitpod via CLI
└── labs/                      # Workspace folder where exercises are deployed
```

---

## 🛠️ Step-by-Step Setup Blueprint

### Step 1: Link GitHub and Gitpod Together
1. Open your web browser and sign up for a free account at GitHub.com. Keep that browser tab open.
2. Open a new tab and navigate to Gitpod.io.
3. Click "Sign In" or "Get Started for Free" and choose "Continue with GitHub".
4. Click the green "Authorize Gitpod" button. Your accounts are now securely linked.

### Step 2: Create an Empty Remote Repository on GitHub
1. On your GitHub dashboard, click the green "New" button (or go to https://github.com/new).
2. Repository name: Type `cloud-training-sandbox`.
3. Set the repository visibility to Public.
4. CRITICAL: Leave "Add a README file", "Add .gitignore", and "Choose a license" UNCHECKED. We want a completely empty slate.
5. Click "Create repository". Keep this page open.

### Step 3: Initialize Git and Folders on Your Local Mac
1. Open the Terminal app on your Mac (Cmd + Space, type Terminal, hit Enter).
2. Check if Git is installed by running `git --version`. If macOS prompts you with a pop-up window asking to install the "command line developer tools", click Install and let it finish.
3. Copy, paste, and run this entire block to create your scaffolding and initialize git:
   ```bash
   mkdir -p ~/Desktop/cloud-training-sandbox/bin
   mkdir -p ~/Desktop/cloud-training-sandbox/labs
   cd ~/Desktop/cloud-training-sandbox
   git init
   ```
4. Set up your global Git identity configurations (replace with your information):
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your_email@example.com"
   ```

### Step 4: Write the Installer Scripts Globally (bin/)
1. Open VS Code Desktop on your Mac.
2. Go to File > Open Folder..., navigate to your Desktop, select `cloud-training-sandbox`, and click Open.
3. In the left sidebar, hover over the bin folder, click the New File icon, and create the following five files. Copy and paste their respective codes:

#### File 1: bin/install-terraform
```bash
#!/usr/bin/env bash
echo "==> Upgrading system packages and installing Terraform..."
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl unzip python3-pip python3-venv
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com \$(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
```

#### File 2: bin/install-aws-cli
```bash
#!/usr/bin/env bash
echo "==> Downloading and mounting official Amazon AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip && sudo ./aws/install && rm -rf aws awscliv2.zip
```

#### File 3: bin/install-azure-cli
```bash
#!/usr/bin/env bash
echo "==> Injecting Microsoft Azure software tracking layers..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

#### File 4: bin/install-cloudgoat
```bash
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
```

#### File 5: bin/set-gitpod-variables
```bash
#!/usr/bin/env bash
# Check if gitpod CLI is installed locally
if ! command -v gitpod &> /dev/null; then
    echo "❌ Gitpod CLI not found on your Mac. Please run 'brew install gitpod-io/tap/gitpod' first."
    exit 1
fi

# Prompt for values securely
read -p "Enter your GitHub Username: " GH_USER
read -p "Enter AWS Access Key ID: " AWS_KEY
read -s -p "Enter AWS Secret Access Key: " AWS_SECRET
echo ""

# Push variables to your Gitpod cloud account using the CLI
echo "⏳ Uploading configurations to Gitpod cloud repository pattern..."
gitpod environment set AWS_ACCESS_KEY_ID="$AWS_KEY" --repository="$GH_USER/*"
gitpod environment set AWS_SECRET_ACCESS_KEY="$AWS_SECRET" --repository="$GH_USER/*"
echo "✅ Variables mapped securely to Gitpod dashboard for scope: $GH_USER/*"
```

### Step 5: Grant Script Permissions on Your Mac
Go back to your independent Mac Terminal window (which is pointing inside `cloud-training-sandbox`) and flag these files as executable binary scripts by running:
```bash
chmod +x bin/*
```

### Step 6: Create the Orchestration Blueprint (.gitpod.yml)
In the root space of your VS Code folder (not inside bin or labs), create a file named exactly `.gitpod.yml` and paste this content inside:

```yaml
image: gitpod/workspace-full

tasks:
  - name: Global Environment Provisioner
    before: |
      cd \$GITPOD_REPO_ROOT
    init: |
      ./bin/install-terraform
    command: |
      echo "✅ Core Infrastructure Ready."
      terraform -version

  - name: CloudGoat & AWS Track
    command: |
      echo "🚀 Setting up CloudGoat Engine..."
      ./bin/install-aws-cli
      ./bin/install-cloudgoat
      source ~/.bashrc
      clear
      echo "🛡️ CloudGoat Engine Ready!"
      echo "💡 Use shortcuts: cg-list, cg-create [lab], cg-destroy [lab]"

  - name: Azure Track Optional Provisioner
    command: |
      echo "💡 To load Microsoft Azure labs, execute: ./bin/install-azure-cli"

vscode:
  extensions:
    - hashicorp.terraform
    - amazonwebservices.aws-toolkit-vscode
    - ms-vscode.azurecli
```

### Step 7: Create the Safety Filter Configuration (.gitignore)
To make sure you don't accidentally push target lab data, secrets, or tracking tokens back into public source control, create a new file named exactly `.gitignore` in your root workspace path and paste this layout:

```text
# Ignore cloud environment keys and local settings
.gitpod/
.vscode/

# Ignore local terraform runtime and state engine architectures
.terraform/
*.tfstate
*.tfstate.backup
.terraform.lock.hcl

# Ignore all dynamic dependencies and labs generated by CloudGoat
labs/cloudgoat/
```

### Step 8: Create Your AWS IAM Credentials
1. Log into your AWS Management Console, search for IAM and open it.
2. Click Users on the left menu, then click the orange Create user button on the top right.
3. Name the user `gitpod-cloudgoat-admin`. Leave the Console access box unchecked. Click Next.
4. Select Attach policies directly, check AdministratorAccess, click Next, and click Create user.
5. Select your new user from the list, click the Security credentials tab, scroll down to Access keys, and click Create access key.
6. Choose Command Line Interface (CLI), check the confirmation box, click Next, and then click Create access key.
7. Copy both the Access key ID and the Secret access key strings securely to a temporary notepad file.

### Step 9: Execute the Variable Auto-Provisioning Script
1. On your Mac Terminal (while inside the project folder), install the Gitpod CLI and log in by running:
   ```bash
   brew install gitpod-io/tap/gitpod
   gitpod login
   ```
2. Run your new custom script tool:
   ```bash
   ./bin/set-gitpod-variables
   ```
3. Input your GitHub username, AWS Key, and Secret key when prompted. The script pushes them straight to your Gitpod cloud account profiles.

### Step 10: Push Everything Up to GitHub
1. Return to your Mac Terminal window.
2. Commit your staging items locally and push them online:
   ```bash
   git add .
   git commit -m "feat: implement framework with automation tools"
   git branch -M main
   ```
3. Copy the specific `git remote add origin` line shown on your unique GitHub page under the section "...or push an existing repository from the command line" and run it. Example:
   ```bash
   git remote add origin https://github.com/YOUR_GITHUB_USERNAME/cloud-training-sandbox.git
   ```
4. Push to the cloud:
   ```bash
   git push -u origin main
   ```

### Step 11: Configure Gitpod to Launch in Local VS Code
1. Navigate to your browser and log into https://gitpod.io/preferences.
2. Find the Editor configuration setting and change the toggle selection from VS Code (Browser) to VS Code Desktop.

### Step 12: Launch and Connect
1. Go to your GitHub repository page in your browser.
2. Click on the URL address bar and prepend `https://gitpod.io/#` directly onto your GitHub string.
   * Example: `https://gitpod.io/#https://github.com/YOUR_GITHUB_USERNAME/cloud-training-sandbox`
3. Hit Enter. Confirm the browser prompt. Your local Mac VS Code will open and hook straight into the live cloud sandbox over a secure SSH tunnel.

---

## 🥷 How to Use the CloudGoat Shortcuts

Run these commands directly inside your terminal panel within your local VS Code application:

### 1. Configure CloudGoat Profile and Firewall Whitelist
```bash
cg config profile default
cg config whitelist --auto
```

### 2. List All Available Scenarios
```bash
cg-list
```

### 3. Create and Spin Up a Scenario
```bash
cg-create iam_privesc_by_rollback
```

### 4. Tear Down and Destroy a Scenario (CRITICAL for cost control)
```bash
cg-destroy iam_privesc_by_rollback
```
"""