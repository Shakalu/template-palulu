# Dockerfile kali-light

# Official base image
FROM kalilinux/kali-rolling

# define environment
ENV SCREEN_WIDTH 1280
ENV SCREEN_HEIGHT 800
ENV SCREEN_DEPTH 16
ENV PASSWORD coreemu
ENV DEBIAN_FRONTEND noninteractive



# Apt
RUN apt -y update && apt -y upgrade && apt -y autoremove && apt clean

# Tools
#RUN apt install kali-linux-large -y --no-install-recommends

RUN apt install kali-desktop-kde -y --no-install-recommends


# Set working directory to /root
WORKDIR /root

# install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    logrotate \
    python3-numpy \
    supervisor \
    x11vnc \
    xvfb \
    git \
    unzip

# install novnc
RUN mkdir -p ~/.vnc

RUN git config --global http.sslverify false
RUN cd /root && git clone https://github.com/novnc/noVNC.git && \
    cd noVNC/utils && git clone https://github.com/novnc/websockify websockify

RUN cd /root/noVNC && ln -sf vnc.html index.html
ADD ./config/ /root/.config/
ADD bg/ /root/
ADD etc/supervisor/conf.d /etc/supervisor/conf.d
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ADD extra /extra
VOLUME /root/shared
# noVNC
EXPOSE 7080
# VNC
EXPOSE 5900


ENTRYPOINT "/entrypoint.sh"
