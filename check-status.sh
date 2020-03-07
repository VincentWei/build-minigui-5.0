#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

for comp in minigui-res mg-samples minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-demos cell-phone-ux-demo; do
    echo
    echo "CHECKING STATUS IN $comp..."
    cd $comp
    git status
    cd ..
done
