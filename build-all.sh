#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

cd minigui
./autogen.sh; ./configure $GOPTS --with-runmode=$RUNMODE $MGOPTS
make clean; make -j$NR_JOBS; sudo make install
cd ..

for comp in minigui-res mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-tools mg-samples mg-demos cell-phone-ux-demo; do
    cd $comp
    ./autogen.sh; ./configure $GOPTS
    make clean; make -j$NR_JOBS; sudo make install
    cd ..
done
