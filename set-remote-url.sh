#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

# GVFB
cd gvfb; git remote set-url origin $REPO_URL/gvfb.git; cd ..

# The third-party libraries
for comp in harfbuzz chipmunk; do
    cd 3rd-party/$comp; git remote set-url origin $REPO_URL/$comp.git; cd ../..
done

# MiniGUI, MiniGUI components and samples
for comp in minigui-res minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-samples mg-demos; do
    cd $comp; git remote set-url origin $REPO_URL/$comp.git; cd ..
done

# Tools and demos
for comp in mg-tools cell-phone-ux-demo; do
    cd $comp; git remote set-url origin $REPO_URL/$comp.git; cd ..
done

