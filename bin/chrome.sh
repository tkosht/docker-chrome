#!/usr/bin/sh

export PATH=$PATH:/opt/chrome-linux64

url="https://www.yahoo.co.jp"
if [ "$1" != "" ]; then
    url="$1"
fi

chrome \
    --no-sandbox \
    --disable-dev-shm-usage \
    --enable-chrome-browser-cloud-management \
    --start-maximized \
    $url

