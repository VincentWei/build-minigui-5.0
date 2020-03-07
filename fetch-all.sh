#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

# GVFB
git clone $REPO_URL/gvfb.git

# The third-party libraries
for comp in harfbuzz chipmunk; do
    cd 3rd-party; git clone $REPO_URL/$comp.git; cd ..
done

# MiniGUI, MiniGUI components and samples, demos
for comp in minigui-res minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-tools mg-samples mg-demos cell-phone-ux-demo; do
    git clone $REPO_URL/$comp.git -b $BRANCH_NAME
done

