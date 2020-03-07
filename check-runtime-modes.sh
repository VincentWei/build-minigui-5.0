#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

RUNMODE="CURRENT RUNTIME INSTALLED"

check_minigui_components() {
    for comp in mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-tools mg-samples mg-demos cell-phone-ux-demo; do
        cd $comp
        ./configure --disable-static && make clean && make -j$NR_JOBS && sudo make install
        if [ "$?" != "0" ]; then
            echo "====="
            echo "ERROR WHEN COMPILING $comp FOR $RUNMODE"
            echo "====="
            exit 1
        fi
        cd ..
    done
}

check_minigui_test() {
    for comp in mgutils mg-tests; do
        cd $comp
        ./configure --disable-static && make clean && make -j$NR_JOBS && sudo make install
        if [ "$?" != "0" ]; then
            echo "====="
            echo "ERROR WHEN COMPILING $comp FOR $RUNMODE"
            echo "====="
            exit 1
        fi
        cd ..
    done
}

check_minigui_ths() {
    RUNMODE="MINIGUI THREADS"
    cd minigui
    ./configure --disable-static --with-runmode=ths --enable-develmode && make clean && make -j$NR_JOBS && sudo make install
    if [ "$?" != "0" ]; then
        echo "====="
        echo "ERROR WHEN COMPILING minigui FOR $RUNMODE"
        echo "====="
        exit 1
    fi
    cd ..

    check_minigui_components
}

check_minigui_ths_incore() {
    RUNMODE="MINIGUI THREADS WITH INCORE RESOURCE"
    cd minigui
    ./configure --disable-static --with-runmode=ths --enable-incoreres --enable-develmode && make clean && make -j$NR_JOBS && sudo make install
    if [ "$?" != "0" ]; then
        echo "====="
        echo "ERROR WHEN COMPILING minigui FOR $RUNMODE"
        echo "====="
        exit 1
    fi
    cd ..

    check_minigui_components
}

check_minigui_ths_nocursor() {
    RUNMODE="MINIGUI THREADS WITH NO CURSOR"
    cd minigui
    ./configure --disable-static --with-runmode=ths --disable-cursor --enable-develmode && make clean && make -j$NR_JOBS && sudo make install
    if [ "$?" != "0" ]; then
        echo "====="
        echo "ERROR WHEN COMPILING minigui FOR $RUNMODE"
        echo "====="
        exit 1
    fi
    cd ..

    check_minigui_components
}

check_minigui_sa() {
    RUNMODE="MINIGUI STANDALONE"
    cd minigui
    ./configure --disable-static --with-runmode=sa --enable-develmode && make clean && make -j$NR_JOBS && sudo make install
    if [ "$?" != "0" ]; then
        echo "====="
        echo "ERROR WHEN COMPILING minigui FOR $RUNMODE"
        echo "====="
        exit 1
    fi
    cd ..

    check_minigui_components
}

check_minigui_procs_sharedfb() {
    RUNMODE="MINIGUI PROCESSES WITH SHAREDFB SCHEMA"
    cd minigui
    ./configure --disable-static --with-runmode=procs --disable-compositing --enable-develmode && make clean && make -j$NR_JOBS && sudo make install
    if [ "$?" != "0" ]; then
        echo "====="
        echo "ERROR WHEN COMPILING minigui FOR $RUNMODE"
        echo "====="
        exit 1
    fi
    cd ..

    check_minigui_components
}

check_minigui_procs_compos() {
    RUNMODE="MINIGUI PROCESSES WITH COMPOSITING SCHEMA"
    cd minigui
    ./configure --disable-static --with-runmode=procs --enable-compositing --enable-develmode && make clean && make -j$NR_JOBS && sudo make install
    if [ "$?" != "0" ]; then
        echo "====="
        echo "ERROR WHEN COMPILING minigui FOR $RUNMODE"
        echo "====="
        exit 1
    fi
    cd ..
}

check_minigui_with_options() {
    RUNMODE="MiniGUI configured with $1"
    cd minigui
    ./configure --disable-static --enable-develmode $1 && make clean && make -j$NR_JOBS && sudo make install
    if [ "$?" != "0" ]; then
        echo "====="
        echo "ERROR WHEN COMPILING minigui FOR $RUNMODE"
        echo "====="
        exit 1
    fi
    cd ..

    if [ "x$ONLYTEST" = "xyes" ]; then
        check_minigui_test
    else
        check_minigui_components
    fi
}

check_with_options() {
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

    check_minigui_with_options "$OPTIONS"
}

OPTIONS=( \
    "sa" \
    "sa virtualwindow" \
    "ths" \
    "ths incoreres -cursor" \
    "procs compositing" \
    "sa incoreres -cursor virtualwindow" \
    "sa -cursor -updateregion" \
    "ths -cursor" \
    "ths incoreres" \
    "ths incoreres -cursor -updateregion" \
    "procs -compositing" \
    "procs -compositing incoreres" \
    "procs -compositing incoreres -cursor" \
    "procs compositing -cursor" \
    "procs compositing incoreres" \
    "procs compositing incoreres -cursor" \
    "procs compositing -updateregion" \
    "procs compositing virtualwindow" \
)

if [ $# == 0 ]; then
    ONLYTEST="no"

    if [ -f ".last_option" ]; then 
        last_option=`cat .last_option`

        echo start from last bad running: $last_option

        for i in ${!OPTIONS[*]}
        do
            if [ "$last_option" == "${OPTIONS[$i]}" ]; then
                break
            fi
        done

        for ((j=$i; j<${#OPTIONS[*]}; ++j))  
        do
            option=${OPTIONS[$j]}
            echo $option > .last_option
            check_with_options $option
        done  

    else
        for ((j=0; j<${#OPTIONS[*]}; ++j))  
        do
            option=${OPTIONS[$j]}
            echo $option > .last_option
            check_with_options $option
        done
    fi
else
    ONLYTEST="no"

    echo $* > .last_option
    check_with_options $*
fi

rm .last_option

echo "====="
echo "PASSED"
echo "====="

exit 0
