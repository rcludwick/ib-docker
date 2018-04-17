#!/bin/bash -x

rm -rf /tmp/.X*
rm -rf /root/.Xauthority

export DISPLAY=:99

#Xvfb "$DISPLAY" -screen 0 1024x768x24 -f /root/.Xauthority &
Xvfb "$DISPLAY" -screen 0 1024x768x24 &
sleep 5
#/usr/bin/x11vnc -find -auth /root/.Xauthority -ncache 10 -ncache_cr &
ratpoison &
/usr/bin/x11vnc -display "$DISPLAY" -ncache 10 -ncache_cr &

#xvfb-run /opt/IBController/Scripts/DisplayBannerAndLaunch.sh -f /root/.Xauthority &
/opt/IBController/Scripts/DisplayBannerAndLaunch.sh &
# Tail latest in log dir
sleep 1
tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) &

# Give enough time for a connection before trying to expose on 0.0.0.0:4003
sleep 30
echo "Forking :::4001 onto 0.0.0.0:4003\n"
socat TCP-LISTEN:4003,fork TCP:127.0.0.1:4001

#/etc/init.d/x11vnc start 
