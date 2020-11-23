#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

build_minigui_components() {
    for comp in mgutils mgplus mgeff mgncs mgncs4touch; do
        cd $comp
        ./autogen.sh && ./configure --disable-static $GOPTS && make clean && make -j$NR_JOBS && sudo make install
        if [ "$?" != "0" ]; then
            echo "====="
            echo "ERROR WHEN COMPILING '$comp' FOR $CONFOPT"
            echo "====="
            exit 1
        fi
        cd ..
    done

    for comp in mg-tools; do
        cd $comp
        ./autogen.sh && ./configure --disable-static && make clean && make -j$NR_JOBS && sudo make install
        if [ "$?" != "0" ]; then
            echo "====="
            echo "ERROR WHEN COMPILING '$comp' FOR $CONFOPT"
            echo "====="
            exit 1
        fi
        cd ..
    done

    for comp in mg-tests mg-samples mg-demos cell-phone-ux-demo; do
        cd $comp
        ./autogen.sh && ./configure --disable-static && make clean && make -j$NR_JOBS
        if [ "$?" != "0" ]; then
            echo "====="
            echo "ERROR WHEN COMPILING '$comp' FOR $CONFOPT"
            echo "====="
            exit 1
        fi
        cd ..
    done
}


build_minigui_with_options() {
    CONFOPT="MiniGUI configured with $1"
    cd minigui
    ./autogen.sh && ./configure --disable-static $GOPTS $1 && make clean && make -j$NR_JOBS && sudo make install
    if [ "$?" != "0" ]; then
        echo "====="
        echo "ERROR WHEN COMPILING 'minigui' FOR $CONFOPT"
        echo "====="
        exit 1
    fi
    cd ..

    build_minigui_components
}

build_with_options() {
    OPTIONS="--with-runmode=$1"

    index=1
    for i in $*
    do
        if [ $index != 1 ]; then
            if [ ${i:0:1} = "-" ]; then
                OPTIONS="$OPTIONS --disable$i"
            else
                OPTIONS="$OPTIONS --enable-$i"
            fi
        fi
        let index+=1
    done

    build_minigui_with_options "$OPTIONS"
}

if [ $# == 0 ]; then
    build_with_options procs compositing virtualwindow
else
    build_with_options $*
fi

echo "====="
echo "BUILDING FINISHED FOR $CONFOPT"
echo "====="

exit 0
