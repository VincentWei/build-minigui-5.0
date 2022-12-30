#!/bin/bash

tag=ver-5-0-11

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

for comp in minigui-res mg-samples minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-demos cell-phone-ux-demo; do
    echo "DELETING TAG ON $comp..."
    cd $comp
    git tag -d $tag
    git push origin :refs/tags/$tag
    cd ..
done
