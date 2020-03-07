#!/bin/bash
export NOW_DIR=$PWD
export SCRIPTS_DIR=$NOW_DIR/deb-scripts
CLEAN_BUILD="0"
RUN_MODE=""

Usage()
{
    echo "========Usage======="
    echo "Compile: $0 <build|clean-build> [gvfb deb](must have >1)"
    echo "Cleanup: $0 build clean"
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
    VERSION=`grep PROJECT\(gvfb $GVFB_SRC/CMakeLists.txt | awk -F'[-)]' '{print $2}'`
    if [ "$BIT" == "32" ]
    then
        ARCHITECTURE="i386"
    else
        ARCHITECTURE="amd64"
    fi
    mkdir -p $OUT_PATH
    mkdir -p $OUT_PATH/DEBIAN
    cp -v deb-scripts/DEBIAN/control-gvfb $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${VERSION}:'"$VERSION"':g' $OUT_PATH/DEBIAN/control
    sed -i -e 's:\${ARCHITECTURE}:'"$ARCHITECTURE"':g' $OUT_PATH/DEBIAN/control
    mkdir -p $DEB_PATH
    dpkg -b $OUT_PATH $DEB_PATH/gvfb_"$VERSION"_"$ARCHITECTURE".deb
}


###########################################
build_gvfb()
{
    cd $GVFB_SRC || ERROR
    CLEAN
    $SCRIPTS_DIR/build-config-gvfb
    cd $NOW_DIR
}

###########################################

if [ $# -lt 2 ]
then
    Usage; exit -1
fi

if [ "$1" == "build" ]
then
    CLEAN_BUILD="0"
elif [ "$1" == "clean-build" ]
then
    CLEAN_BUILD="1"
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
