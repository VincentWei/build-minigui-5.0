#!/bin/bash

branch=master

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

for comp in minigui-res mg-samples minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-demos; do
    echo "checkout branch $branch for $comp..."
    cd $comp
    git checkout $branch && git pull
    cd ..
done

# gvfb, mg-tools, and cell-phone-ux-demo are always in master
