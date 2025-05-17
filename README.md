# RobPrian - Linux SSH Environment on Fly.io

This project sets up a **Linux SSH environment** on Fly.io with a complete **development environment**. It uses **Ubuntu 24.04** with an **SSH server** running on a custom user "robby", whose home directory is located at `/robby` with a **50GB volume**.

## Features

- **SSH access** via port `1995`
- **Node.js** with **npm** and **Yarn** pre-installed
- **Python 3** with **pipx**, **pipenv**, and **poetry**
- **Bash** with custom configuration and **neofetch** welcome screen
- **Development tools**: git, vim, nano, htop, tmux, jq, tree, rsync
- **Security enhancements**:
  * fail2ban for SSH protection
  * rkhunter for rootkit detection
  * SSH hardening
- **Custom home directory** for user `robby` at `/robby`
- **Full volume (50GB)** dedicated to `/robby`
- **All ports open** for running various services
- **Asia/Jakarta timezone**

## Setup

### Prerequisites
- You need to have a **Fly.io account** and **Fly CLI** installed on your system.
- Create a **Fly.io application** using the command:
  
  ```bash
  fly launch
  ```

### Configuration

1. **Fly.toml Configuration**
   The fly.toml file defines the configuration for the Fly.io app, including the volume size and exposed ports.

   ```toml
   app = "robprian"
   primary_region = "sin"

   [build]
     dockerfile = "Dockerfile"

   [vm]
     size = "shared-cpu-1x"
     memory = "1gb"

   [[mounts]]
     source = "robby_data"
     destination = "/robby"
     initial_size = "50gb"

   [[services]]
     protocol = "tcp"
     internal_port = 1995

     [[services.ports]]
       port = 1995
   ```

## How to Deploy

1. **Deploy the application**:

   Run the following command to deploy the app:

   ```bash
   fly deploy
   ```

2. **Access via SSH**:

   After deploying, access the server via SSH at port 1995:

   ```bash
   ssh robby@robprian.fly.dev -p 1995
   ```
   
   Password: `P4ks1m1n`

3. **Using Node.js, npm, and Yarn**:

   Node.js, npm, and Yarn are pre-installed for the `robby` user. You can use them right away after SSH login:

   ```bash
   # Verify Node.js version
   node -v

   # Verify npm version
   npm -v

   # Verify Yarn version
   yarn -v

   # Create a new Node.js project
   mkdir my-project
   cd my-project
   yarn init -y
   ```

4. **Using Python and its tools**:

   Python 3 with pipx, pipenv, and poetry are pre-installed:

   ```bash
   # Verify Python version
   python3 --version

   # Create a virtual environment
   python3 -m venv myenv
   source myenv/bin/activate

   # Or use pipenv
   pipenv --python 3
   pipenv shell

   # Or use poetry
   poetry init
   poetry shell
   ```

## Files in the Project

- **Dockerfile**: Sets up the environment and installs necessary packages including Node.js, Python, and development tools.
- **entry.sh**: The entrypoint script to configure SSH, security services, hostname, and timezone.
- **.profile**: User profile configuration with neofetch welcome screen.
- **.bashrc**: Bash configuration with custom prompt, aliases, and git integration.
- **fly.toml**: Configuration for Fly.io app deployment with SSH and other ports.

## Customization

- **Bash configuration**: You can customize the bash prompt and aliases by editing `~/.bashrc`.
- **SSH security**: Additional SSH security settings can be configured in `/robby/ssh/sshd_config`.
- **Neofetch**: The welcome screen is provided by neofetch and can be customized.

## Troubleshooting

- If you're unable to connect via SSH, check the firewall settings in entry.sh.
- Ensure that the volume size is properly configured in fly.toml (50GB) to avoid issues with space.
- Check fail2ban logs at `/var/log/fail2ban.log` if you're having SSH access issues.

## License

MIT License. See LICENSE for more details.
