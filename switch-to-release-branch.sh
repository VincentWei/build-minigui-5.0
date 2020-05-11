#!/bin/bash

branch=rel-5-0

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

for comp in minigui-res mg-samples minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-demos; do
    echo "checkout branch $branch for $comp..."
    cd $comp
    git branch $branch; git pull && git checkout $branch
    git branch --set-upstream-to=origin/$branch $branch
    cd ..
done

# gvfb, mg-tools, and cell-phone-ux-demo are always in master
