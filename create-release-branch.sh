#!/bin/bash

branch=rel-5-0

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

for comp in minigui-res mg-samples minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-demos; do
    echo "create branch $branch for $comp..."
    cd $comp
    git branch $branch && git checkout $branch && git push --set-upstream origin $branch
    cd ..
done

# gvfb, mg-tools, and cell-phone-ux-demo are always in master
