#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

echo "BUILDING gvfb"
cd gvfb
mkdir build
cd build
cmake ..
make -j$NR_JOBS; sudo make install
cd ../..

echo "BUILDING chipmunk"
cd 3rd-party/chipmunk
mkdir build
cd build
cmake ..
make -j$NR_JOBS; sudo make install
cd ../../..

echo "INSTALL MiniGUI resource files"
cd minigui-res/
./autogen.sh && ./configure && make && sudo make install
cd ..

