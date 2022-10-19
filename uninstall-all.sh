#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

echo UNINSTALL TOOLS, TESTS, SAMPLES, AND DEMOS NOW...
for comp in mg-tools mg-tests mg-samples mg-demos cell-phone-ux-demo; do
    cd $comp
    ./autogen.sh && ./config.status && sudo make uninstall && make clean
    cd ..
done
echo UNINSTALL AND CLEAN COMPONENTS...
for comp in minigui-res mgncs4touch mgncs mgeff mgplus mgutils; do
    cd $comp
    ./autogen.sh && ./config.status && sudo make uninstall && make clean
    cd ..
done

echo UNINSTALL MiniGUI THEN...
cd minigui
./autogen.sh && ./config.status && sudo make uninstall && make clean
cd ..

