#!/bin/bash

branch=rel-4-0

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

for comp in minigui-res mg-samples minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-demos; do
    echo "MAKING TAG IN $comp..."
    cd $comp
    git pull && git checkout rel-4-0
    cd ..
done

# gvfb, mg-tools, and cell-phone-ux-demo are always in master
