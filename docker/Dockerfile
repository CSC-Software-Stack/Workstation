FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble
# BASED ON WEBTOP
# set version label
ARG BUILD_DATE
ARG VERSION
ARG DEBIAN_FRONTEND="noninteractive"

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
  ayatana-indicator-application \
  mate-applets \
  mate-applet-brisk-menu \
  mate-terminal \
  mate-system-monitor \
  pluma \
  wget \
  ubuntu-mate-artwork \
  ubuntu-mate-default-settings \
  ubuntu-mate-desktop \
  fonts-noto \
  ubuntu-mate-icon-themes && \
  echo "**** chrome ****" && \
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
  apt -f install ./google-chrome-stable_current_amd64.deb -y && \
  rm ./google-chrome-stable_current_amd64.deb && \
  echo "**** mate tweaks ****" && \
  rm -f \
  /etc/xdg/autostart/mate-power-manager.desktop \
  /etc/xdg/autostart/mate-screensaver.desktop && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
  /config/.cache \
  /config/.launchpadlib \
  /var/lib/apt/lists/* \
  /var/tmp/* \
  /tmp/*

# MINIFORGE (includes mamba by default, uses conda-forge channel)
RUN \
  echo "**** install additional development packages ****" && \
  apt-get update --fix-missing && \
  apt-get install -y \ 
  build-essential \
  bzip2 \
  ca-certificates \
  curl \
  libglib2.0-0 \ 
  libxext6 \
  libsm6 \
  libxrender1 \
  nano \
  git \
  mercurial \
  subversion && \
  echo "**** install uv ****" && \
  curl -LsSf https://astral.sh/uv/install.sh | sh && \
  echo "**** install miniforge ****" && \
  wget --quiet https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O ~/miniforge.sh && \
  bash ~/miniforge.sh -p /miniforge -b && \
  rm ~/miniforge.sh


ENV PATH="/miniforge/bin:${PATH}"
ENV OPENSSL_CONF=/etc/ssl/openssl.cnf

# VS CODE
RUN \
  wget --quiet https://go.microsoft.com/fwlink/?LinkID=760868 -O ~/vscode.deb && \
  apt install ~/vscode.deb -y && \
  rm ~/vscode.deb 

RUN \
  add-apt-repository universe -y && \
  apt update && \
  apt install dconf-cli dconf-editor -y && \
  apt install caja-open-terminal -y && \
  apt install file-roller -y && \
  wget https://github.com/shiftkey/desktop/releases/download/release-3.4.9-linux1/GitHubDesktop-linux-amd64-3.4.9-linux1.deb && \
  apt install ./GitHubDesktop-linux-amd64-3.4.9-linux1.deb -y && \
  rm GitHubDesktop-linux-amd64-3.4.9-linux1.deb

# add local files
COPY /root /
COPY /setup /setup

# Ensure scripts are executable by all users
RUN chmod +x /etc/cont-init.d/* 2>/dev/null || true && \
    chmod +x /etc/profile.d/*.sh 2>/dev/null || true && \
    chmod -R +x /setup/scripts/ && \
    chmod -R a+r /setup/