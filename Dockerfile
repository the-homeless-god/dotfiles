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

# Зависимости сборки digitwm. Список взят дословно из ветки apt-get функции
# install_digitwm_build_deps (scripts/install-tools.sh), которая, в свою очередь,
# повторяет digitwm/bootstrap.sh. Без них образ не может собрать то, что
# репозиторий заявляет, что ставит. Каждый пакет привязан к делу:
#   build-essential — компилятор C и make (digitwm собирается из исходников)
#   libx11-dev      — заголовки X11      libxft-dev    — заголовки Xft
#   libxrandr-dev   — заголовки Xrandr   bison         — грамматика parse.y
#   pkg-config      — `pkg-config --cflags --libs x11 xft xrandr` в Makefile digitwm
RUN apt-get update && apt-get install -y \
    build-essential \
    libx11-dev \
    libxft-dev \
    libxrandr-dev \
    bison \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

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

# ГРАНИЦА ПРОВЕРКИ. Этот образ может СОБРАТЬ digitwm: компиляция и линковка
# X11-приложения не требуют дисплея. ЗАПУСТИТЬ его здесь нельзя — digitwm это
# оконный менеджер X11, а в контейнере нет ни X-сервера, ни DISPLAY. Всё, что
# касается поведения digitwm в работе, проверяется только на живой X-сессии.

# Run tests
CMD ["make", "test-dry-run"]
