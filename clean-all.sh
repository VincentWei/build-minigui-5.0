#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

echo CLEAN TOOLS, TESTS, SAMPLES, AND DEMOS NOW...
for comp in mg-tools mg-tests mg-samples mg-demos cell-phone-ux-demo; do
    cd $comp
    ./config.status && make clean
    cd ..
done
echo CLEAN COMPONENTS...
for comp in minigui-res mgncs4touch mgncs mgeff mgplus mgutils; do
    cd $comp
    ./config.status && make clean
    cd ..
done

echo CLEAN MiniGUI THEN...
cd minigui
./config.status && make clean
cd ..

