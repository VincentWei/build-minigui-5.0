#!/bin/bash

tag=ver-5-0-15

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

for comp in minigui-res mg-samples minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-demos cell-phone-ux-demo; do
    echo "MAKING TAG ON $comp..."
    cd $comp
    git tag $tag
    git push --tags
    git push --tags github
    git push --tags gitee
    cd ..
done
