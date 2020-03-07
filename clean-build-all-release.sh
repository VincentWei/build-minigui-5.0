#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

echo UNINSTALL, MAKE, AND INSTALL MiniGUI FIRST...
cd minigui
./autogen.sh; ./configure --disable-cursor --with-runmode=$RUNMODE
sudo make uninstall; make clean; make -j$NR_JOBS; sudo make install
cd ..

echo UNINSTALL AND CLEAN OTHERS...
for comp in minigui-res mgncs4touch mgncs mgeff mgplus mgutils; do
    cd $comp
    ./autogen.sh; ./configure
    sudo make uninstall; make clean
    cd ..
done

echo MAKE AND INSTALL COMPONENTS NOW...
for comp in minigui-res mgutils mgplus mgeff mgncs mgncs4touch; do
    cd $comp
    make -j$NR_JOBS; sudo make install
    cd ..
done

echo MAKE AND INSTALL TOOLS, SAMPLES, AND DEMOS NOW...
for comp in mg-tools mg-samples mg-demos cell-phone-ux-demo; do
    cd $comp
    ./autogen.sh; ./configure
    make clean; make -j$NR_JOBS; sudo make install
    cd ..
done
