FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    zsh \
    sudo \
    jq \
    vim \
    make \
    tree \
    python3 \
    python3-pip \
    python3-venv

# Create a non-root user
RUN useradd -m -s /bin/zsh -G sudo developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/developer

# Switch to the developer user and set working directory
USER developer
WORKDIR /home/developer

# Clone the dotfiles repository
RUN git clone https://github.com/the-homeless-god/dotfiles.git /home/developer/dotfiles

# Set up the working directory
WORKDIR /home/developer/dotfiles

# Run tests
CMD ["make", "test-dry-run"] 
