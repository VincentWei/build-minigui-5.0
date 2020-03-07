#!/bin/bash
export NOW_DIR=$PWD
export SCRIPTS_DIR=$NOW_DIR/deb-scripts
CLEAN_BUILD="0"
RUN_MODE=""
RUNTIME_MODE_DESC=""

Usage()
{
    echo "========Usage======="
    echo "Compile: $0 <ths|procs|clean-build-ths|clean-build-procs> [minigui mgutils mgplus mgncs mgeff deb](must have >1)"
    echo "Cleanup: $0 <ths|procs> clean)"
}

ERROR()
{
    echo "Error, Will Quit"; exit -1
}

END()
{
    echo "=======Done========="
}

build_clean()
{
    cd $OUT_PATH

    echo -n "Are you sure to delete ALL content in $OUT_PATH folder ? [ Y/N ]:"
    read yes_no
    if [ "$yes_no" == "Y" -o "$yes_no" == "y" ] 
    then
        rm -rf *
    else 
        cd $NOW_DIR
        exit 0 
    fi

    cd $NOW_DIR
}

CLEAN()
{

    if [ "$CLEAN_BUILD" == "1" ] 
    then
    make distclean
    make clean
    fi
}

build_deb()
{
    PACKAGE="libminigui-$RUN_MODE";

    PACKAGE_DEV="$PACKAGE-dev"
    VERSION=`grep MINIGUI_VERSION $MINIGUI_SRC/Makefile | awk '{print $NF}'`
    if [ "$BIT" == "32" ]
    then
        ARCHITECTURE="i386"
    else
        ARCHITECTURE="amd64"
    fi
    mkdir -p $OUT_PATH/DEBIAN
    mkdir -p $DEB_PATH

    sed -i -e 's:'"${OUT_PATH}"'::g' $OUT_PATH/usr/local/lib/pkgconfig/*.pc
    sed -i -e 's:'"${OUT_PATH}"'::g' $OUT_PATH/usr/local/lib/*.la

    # dev
    DEVELOPMENT="Development files for MiniGUI."
    cp deb-scripts/DEBIAN/control-minigui $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${VERSION}:'"$VERSION"':g' $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${ARCHITECTURE}:'"$ARCHITECTURE"':g' $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${PACKAGE}:'"$PACKAGE_DEV"':g' $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${DEVELOPMENT}:'"$DEVELOPMENT"':g' $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${RUNTIME_MODE}:'"$RUNTIME_MODE_DESC"':g' $OUT_PATH/DEBIAN/control
    dpkg -b $OUT_PATH $DEB_PATH/"$PACKAGE_DEV"_"$VERSION"_"$ARCHITECTURE".deb

    # 
    DEVELOPMENT=""
    cp deb-scripts/DEBIAN/control-minigui $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${VERSION}:'"$VERSION"':g' $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${ARCHITECTURE}:'"$ARCHITECTURE"':g' $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${PACKAGE}:'"$PACKAGE"':g' $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${DEVELOPMENT}:'"$DEVELOPMENT"':g' $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${RUNTIME_MODE}:'"$RUNTIME_MODE_DESC"':g' $OUT_PATH/DEBIAN/control
    rm -rf $OUT_PATH/usr/local/include
    dpkg -b $OUT_PATH $DEB_PATH/"$PACKAGE"_"$VERSION"_"$ARCHITECTURE".deb

}


###########################################
# minigui compile
build_minigui()
{
    cd $MINIGUI_SRC || ERROR
    CLEAN
    ./autogen.sh
    $SCRIPTS_DIR/build-config-minigui $1
    cd $NOW_DIR
}

build_mgutils()
{
    cd $MGUTILS_SRC || ERROR
    CLEAN
    ./autogen.sh
    $SCRIPTS_DIR/build-config-mgutils $1
    cd $NOW_DIR
}

build_mgplus()
{
    cd $MGPLUS_SRC || ERROR
    CLEAN
    ./autogen.sh
    $SCRIPTS_DIR/build-config-mgplus $1
    cd $NOW_DIR
}

build_mgncs()
{
    cd $MGNCS_SRC || ERROR
    CLEAN
    ./autogen.sh
    $SCRIPTS_DIR/build-config-mgncs
    cd $NOW_DIR
}

build_mgeff()
{
    cd $MGEFF_SRC || ERROR
    CLEAN
    ./autogen.sh
    $SCRIPTS_DIR/build-config-mgeff
    cd $NOW_DIR
}

###########################################

if [ $# -lt 2 ]
then
    Usage; exit -1
fi

if [ "$1" == "ths" ]
then
    CLEAN_BUILD="0"
    RUN_MODE="ths"
    RUNTIME_MODE_DESC="threads"
    source $SCRIPTS_DIR/minigui-ths-configure    
    source $SCRIPTS_DIR/minigui-res-ths-configure    
elif [ "$1" == "procs" ]
then
    CLEAN_BUILD="0"
    RUN_MODE="procs"
    RUNTIME_MODE_DESC="processes"
    source $SCRIPTS_DIR/minigui-procs-configure    
    source $SCRIPTS_DIR/minigui-res-procs-configure    
elif [ "$1" == "clean-build-ths" ]
then
    CLEAN_BUILD="1"
    RUN_MODE="ths"
    RUNTIME_MODE_DESC="threads"
    source $SCRIPTS_DIR/minigui-ths-configure    
    source $SCRIPTS_DIR/minigui-res-ths-configure    
elif [ "$1" == "clean-build-procs" ]
then
    CLEAN_BUILD="1"
    RUN_MODE="procs"
    RUNTIME_MODE_DESC="processes"
    source $SCRIPTS_DIR/minigui-procs-configure    
    source $SCRIPTS_DIR/minigui-res-procs-configure    
else
    Usage
    exit -1
fi

source $SCRIPTS_DIR/build-prepare 

if [ ! -d "$PREFIX" ]; then
mkdir -p "$PREFIX"
fi

hasCC_BIN=`echo $PATH | grep $CROSSCOMPILER_BIN`
if [ "$hasCC_BIN" == "" ]
then
    export PATH="$PATH:$CROSSCOMPILER_BIN"
fi

hasPREFIX_BIN=`echo $PATH | grep ${PREFIX}/bin`
if [ "$hasPREFIX_BIN" == "" ]
then
    export PATH="${PREFIX}/bin/:${PATH}"
fi

run_num=0
for product in $*
do
    if [ $run_num -gt 0 ];then
        build_$product $1
    fi
    if [ $product == "clean" ]; then
        echo "done"
        exit 0
    fi
    let run_num=$run_num+1
done

END
