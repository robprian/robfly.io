FROM ubuntu:24.04

# Set non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install common packages and development tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    wget \
    sudo \
    build-essential \
    libssl-dev \
    libffi-dev \
    net-tools \
    iproute2 \
    iputils-ping \
    ufw \
    git \
    unzip \
    bash \
    python3 \
    python3-pip \
    python3-venv \
    vim \
    nano \
    htop \
    tmux \
    jq \
    tree \
    rsync \
    zip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    locales \
    nodejs \
    npm \
    fail2ban \
    rkhunter \
    neofetch \
    figlet \
    && rm -rf /var/lib/apt/lists/*

# Create /robby as the full home + ssh + data base
RUN useradd -m -d /robby -s /bin/bash robby \
    && mkdir -p /robby/ssh \
    && chown -R robby:robby /robby \
    && echo "robby  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set up profile and bashrc files for robby user
USER root
COPY .profile /robby/.profile
COPY .bashrc /robby/.bashrc
RUN chown robby:robby /robby/.profile /robby/.bashrc

# Install Node.js and Yarn globally
RUN npm install -g yarn

# Set up Python environment using apt or with the break-system-packages flag
RUN apt-get update && apt-get install -y python3-pip python3-venv python3-virtualenv pipx && \
    pipx install pipenv && \
    pipx install poetry && \
    ln -s /root/.local/bin/pipenv /usr/local/bin/pipenv && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

# Configure fail2ban for SSH
RUN mkdir -p /etc/fail2ban/jail.d \
    && echo '[sshd]\nenabled = true\nport = 1995\nfilter = sshd\nlogpath = /var/log/auth.log\nmaxretry = 5\nbantime = 3600' > /etc/fail2ban/jail.d/ssh.conf

# Remove default ssh config, we'll link it later
RUN rm -rf /etc/ssh

# Copy entry script and ensure it has the correct permissions and line endings
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh && \
    # Convert potential Windows line endings to Unix
    sed -i 's/\r$//' /entry.sh

# Expose ports
EXPOSE 1995
EXPOSE 80
EXPOSE 443
EXPOSE 3000-3999
EXPOSE 8000-8999
EXPOSE 5432
EXPOSE 6379
EXPOSE 9000
EXPOSE 9001

CMD ["/entry.sh"]
