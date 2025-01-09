FROM alpine:latest

# Install minimal build requirements
RUN apk add --no-cache \
    sudo \
    bash \
    build-base \
    && rm -rf /var/cache/apk/*

# Set up locale
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Create test user
RUN adduser -D -s /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to developer user
USER developer
WORKDIR /home/developer

# Copy repository and set permissions
COPY --chown=developer:developer . /home/developer/dotfiles
RUN chmod +x /home/developer/dotfiles/scripts/*.sh

# Run installation (interactive mode)
CMD ["/bin/bash", "-c", "cd /home/developer/dotfiles/scripts && ./install-tools.sh"] 
