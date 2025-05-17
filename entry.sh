#!/bin/bash
set -e

# Init SSH password from environment variable or use default
SSH_PASSWORD=${SSH_PASSWORD:-"KATASANDIKAMU"}
echo "robby:${SSH_PASSWORD}" | chpasswd

# Set hostname to robprian
echo "robprian" > /etc/hostname
hostname robprian

# Set hosts entry
echo "127.0.0.1 robprian localhost" > /etc/hosts
echo "::1 robprian localhost ip6-localhost ip6-loopback" >> /etc/hosts

# Set timezone to Asia/Jakarta
rm -f /etc/localtime
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
echo "Asia/Jakarta" > /etc/timezone

# Buat symlink SSH config ke volume
mkdir -p /robby/ssh
ln -sf /robby/ssh /etc/ssh

# Generate SSH host keys jika belum ada
if [ ! -f /robby/ssh/ssh_host_rsa_key ]; then
    mkdir -p /robby/ssh
    ssh-keygen -A
    cp -f /etc/ssh/* /robby/ssh/
fi

# Aktifkan SSH server di port 1995 dan listen on all interfaces
echo "Port 1995" > /robby/ssh/sshd_config
echo "ListenAddress 0.0.0.0" >> /robby/ssh/sshd_config
echo "HostKey /robby/ssh/ssh_host_rsa_key" >> /robby/ssh/sshd_config
echo "HostKey /robby/ssh/ssh_host_ecdsa_key" >> /robby/ssh/sshd_config
echo "HostKey /robby/ssh/ssh_host_ed25519_key" >> /robby/ssh/sshd_config
echo "PermitRootLogin no" >> /robby/ssh/sshd_config
echo "MaxAuthTries 3" >> /robby/ssh/sshd_config
echo "PasswordAuthentication yes" >> /robby/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /robby/ssh/sshd_config
echo "UsePAM yes" >> /robby/ssh/sshd_config
echo "Subsystem sftp /usr/lib/openssh/sftp-server" >> /robby/ssh/sshd_config
echo "AuthorizedKeysFile %h/.ssh/authorized_keys" >> /robby/ssh/sshd_config
echo "ChallengeResponseAuthentication no" >> /robby/ssh/sshd_config

# Ensure .profile is properly formatted (no Windows line endings)
sed -i 's/\r$//' /robby/.profile
sed -i 's/\r$//' /robby/.bashrc

# Configure bash to source .profile for login shells
echo "# Source .profile for login shells" >> /robby/.bash_profile
echo "if [ -f ~/.profile ]; then" >> /robby/.bash_profile
echo "  . ~/.profile" >> /robby/.bash_profile
echo "fi" >> /robby/.bash_profile
chown robby:robby /robby/.bash_profile

# Disable UFW to allow all ports
ufw --force disable

# Start security services
mkdir -p /var/run/sshd
service fail2ban start || true
service rkhunter start || true

# Create a simple MOTD that runs neofetch
cat > /etc/motd << 'EOF'

EOF

# Create a script to run neofetch at login
cat > /etc/profile.d/01-neofetch.sh << 'EOF'
#!/bin/bash
if [ "$TERM" != "dumb" ]; then
    if command -v neofetch >/dev/null 2>&1; then
        neofetch
    elif command -v figlet >/dev/null 2>&1; then
        figlet "Welcome to RobPrian"
        echo ""
        echo "* SSH port: 1995"
        echo "* Node.js with npm and Yarn is pre-installed"
        echo "* Python 3 with pipx, pipenv, and poetry is available"
        echo "* Bash with custom configuration and neofetch is set up"
        echo "* All ports are open for your convenience"
        echo ""
        echo "For support, visit: https://github.com/robprian/robprian"
    fi
fi
EOF
chmod +x /etc/profile.d/01-neofetch.sh

# Set up a better prompt for root
echo 'export PS1="\[\033[1;31m\][\u@\h \W]#\[\033[0m\] "' >> /root/.bashrc

# Start SSH server explicitly on all interfaces
/usr/sbin/sshd -D -p 1995 -o "ListenAddress=0.0.0.0"
