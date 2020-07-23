#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

# GVFB
git clone $REPO_URL/gvfb.git

# The third-party libraries
for comp in chipmunk; do
    cd 3rd-party; git clone $REPO_URL/$comp.git; cd ..
done

# MiniGUI, MiniGUI components and samples
for comp in minigui-res minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-samples mg-demos; do
    git clone $REPO_URL/$comp.git -b $BRANCH_NAME
done

# Tools and demos
for comp in mg-tools cell-phone-ux-demo; do
    git clone $REPO_URL/$comp.git
done

