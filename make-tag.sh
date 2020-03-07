#!/bin/bash

tag=ver-4-0-5

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

for comp in minigui-res mg-samples minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-demos cell-phone-ux-demo; do
    echo "MAKING TAG IN $comp..."
    cd $comp
    git tag $tag
    git push --tags
    cd ..
done
