#!/bin/bash

# Source custom SSL certificate environment for desktop session
if [[ -f /config/.ssl_env ]]; then
    source /config/.ssl_env
fi

setterm blank 0
setterm powerdown 0
gsettings set org.mate.Marco.general compositing-manager false
/usr/bin/mate-session > /dev/null 2>&1
