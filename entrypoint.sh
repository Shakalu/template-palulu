#!/bin/bash
export GEOMETRY=${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH}
x11vnc -storepasswd ${PASSWORD} ~/.vnc/passwd

#/root/noVNC/utils/novnc_proxy --vnc localhost:5901

exec /usr/bin/supervisord -n
