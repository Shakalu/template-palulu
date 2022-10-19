# #####################################################
# onemarcfifty/kali-linux
# #####################################################
#
# This Dockerfile will build a Kali Linux Docker 
# image with a graphical environment
#
# It takes the following build-args:
# 
#  - the Desktop environment (DESKTOP_ENVIRONMENT)
#  - the remote client you want to use (REMOTE_ACCESS)
#  - the Kali packages to install (KALI_PACKAGE)
#  - ports to use for VNC, SSH, RDP 
#    (RDP_PORT, VNC_DISPLAY, VNC_PORT, SSH_PORT)
#
# The start script is called /startkali.sh
# and it will be built dynamically by the docker build
# process
#
# #####################################################

FROM kalilinux/kali-rolling

ARG DESKTOP_ENVIRONMENT=xfce
ARG REMOTE_ACCESS
ARG KALI_PACKAGE
ARG SSH_PORT=22
ARG RDP_PORT
ARG VNC_PORT=5900
ARG VNC_DISPLAY=0

ENV DEBIAN_FRONTEND noninteractive

# #####################################################
# the desktop environment to use
# if it is null then it will default to xfce
# valid choices are 
# e17, gnome, i3, i3-gaps, kde, live, lxde, mate, xfce
# #####################################################

ENV DESKTOP_ENVIRONMENT=${DESKTOP_ENVIRONMENT:-xfce}
ENV DESKTOP_PKG=kali-desktop-${DESKTOP_ENVIRONMENT}

# #####################################################
# the remote client to use
# if it is null then it will default to x2go
# valid choices are vnc, rdp, x2go
# #####################################################

ENV REMOTE_ACCESS=${REMOTE_ACCESS:-vnc}

# #####################################################
# the kali packages to install
# if it is null then it will default to "default"
# valid choices are arm, core, default, everything, 
# firmware, headless, labs, large, nethunter
# #####################################################

ENV KALI_PACKAGE=${KALI_PACKAGE:-default}
ENV KALI_PKG=kali-linux-${KALI_PACKAGE}

# #####################################################
# install packages that we always want
# #####################################################

RUN apt update -q --fix-missing  
RUN apt upgrade -y
RUN apt -y install --no-install-recommends sudo wget curl dbus-x11 xinit ${DESKTOP_PKG}

# #####################################################
# create the start bash shell file
# #####################################################

RUN echo "#!/bin/bash" > /startkali.sh
#RUN echo "/etc/init.d/ssh start" >> /startkali.sh
RUN chmod 755 /startkali.sh

# #####################################################
# Install the Kali Packages
# #####################################################

RUN apt -y install --no-install-recommends ${KALI_PKG}


RUN if [ "xvnc" = "x${REMOTE_ACCESS}" ] ; \
    then \
        apt -y install --no-install-recommends tigervnc-standalone-server tigervnc-tools; \
        echo "/usr/libexec/tigervncsession-start :${VNC_DISPLAY} " >> /startkali.sh ; \
        echo "echo -e 'shaka' | vncpasswd -f >/root/.vnc/passwd" >> /startkali.sh  ;\
        echo "/usr/share/novnc/utils/novnc_proxy --listen 7080 --vnc localhost:5901 > /var/log/novnc.log 2>&1 &" >> /startkali.sh ; \
        echo "while true; do vncserver -fg -v ; done" >> /startkali.sh ; \
        echo ":${VNC_DISPLAY}=root" >>/etc/tigervnc/vncserver.users ;\
        echo '$localhost = "yes";' >>/etc/tigervnc/vncserver-config-mandatory ;\
        echo '$SecurityTypes = "VncAuth";' >>/etc/tigervnc/vncserver-config-mandatory ;\
        mkdir -p /root/.vnc ;\
        touch /root/.vnc/passwd ;\
        chmod 600 /root/.vnc/passwd ;\
    fi

# ###########################################################
# The /startkali.sh script may terminate, i.e. if we only 
# have statements inside it like /etc/init.d/xxx start
# then once the startscript has finished, the container 
# would stop. We want to keep it running though.
# therefore I just call /bin/bash at the end of the start
# script. This will not terminate and keep the container
# up and running until it is stopped.
# ###########################################################

RUN apt -y install --no-install-recommends git

RUN git config --global http.sslverify false
RUN cd /usr/share/ && \
    git clone https://github.com/novnc/noVNC.git novnc
RUN cd /usr/share/novnc/ && \
    git clone https://github.com/novnc/websockify websockify

RUN cd /usr/share/novnc && ln -sf vnc.html index.html

RUN echo "/bin/bash" >> /startkali.sh

# ###########################################################
# expose the right ports and set the entrypoint
# ###########################################################

WORKDIR "/root"
ENTRYPOINT ["/bin/bash"]
CMD ["/startkali.sh"]