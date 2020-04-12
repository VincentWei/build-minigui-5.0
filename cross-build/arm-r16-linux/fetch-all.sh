#!/bin/bash

# ================ Get global settings ===================
source modify-this-config.sh 
# ================ Get global settings ===================


# ================ Get 3rd-party packages ================
# create 3rd-party directory
rm -fr 3rd-party
mkdir 3rd-party
cd 3rd-party

# get 3rd-party libaries now
for comp in harfbuzz chipmunk; do
    git clone $REPO_URL/$comp.git; 
done

# get zlib-dev
wget http://minigui.org/downloads/common/zlib-1.2.8.tar.gz
tar zxf zlib-1.2.8.tar.gz
rm -f zlib-1.2.8.tar.gz

# get libjpeg-dev
wget http://minigui.org/downloads/common/jpegsrc.v7.tar.gz
tar zxf jpegsrc.v7.tar.gz
rm -f jpegsrc.v7.tar.gz

# get libpng-dev (libpng-dev on Ubuntu Linux 18.04 instead)
wget http://minigui.org/downloads/common/libpng-1.6.36.tar.gz
tar zxf libpng-1.6.36.tar.gz
rm -f libpng-1.6.36.tar.gz

# get libfreetype6-dev
wget http://minigui.org/downloads/common/freetype-2.6.1.tar.gz
tar zxf freetype-2.6.1.tar.gz
rm -f freetype-2.6.1.tar.gz

#get libmtdev
wget http://minigui.org/downloads/common/mtdev-1.1.4.tar.gz
tar zxf mtdev-1.1.4.tar.gz 
rm -f mtdev-1.1.4.tar.gz

#get libudev
wget http://minigui.org/downloads/common/udev-182.tar.gz
tar zxf udev-182.tar.gz
rm -f udev-182.tar.gz

#get libevdev
wget http://minigui.org/downloads/common/libevdev-1.8.0.tar.xz
tar xvJf libevdev-1.8.0.tar.xz
rm -f libevdev-1.8.0.tar.xz

#get kmoddev
wget http://minigui.org/downloads/common/kmod_26.orig.tar.gz
tar zxf kmod_26.orig.tar.gz
rm -f kmod_26.orig.tar.gz

#get libblkid-dev
wget http://minigui.org/downloads/common/util-linux_2.31.1.orig.tar.xz
tar xvJf util-linux_2.31.1.orig.tar.xz
rm -f util-linux_2.31.1.orig.tar.xz

# get libinput-dev
# wget https://www.freedesktop.org/software/libinput/libinput-1.10.0.tar.xz
wget http://minigui.org/downloads/common/libinput_1.2.3.orig.tar.xz
tar xvJf libinput_1.2.3.orig.tar.xz
rm -f libinput_1.2.3.orig.tar.xz

# get libdrm-dev
wget http://minigui.org/downloads/common/libdrm_2.4.99.orig.tar.gz
tar zxf libdrm_2.4.99.orig.tar.gz
rm -f libdrm_2.4.99.orig.tar.gz

# get  libsqlite3-dev
wget http://minigui.org/downloads/common/sqlite-autoconf-3310100.tar.gz
tar zxf sqlite-autoconf-3310100.tar.gz
rm -f sqlite-autoconf-3310100.tar.gz

cd ..
# ================ Get 3rd-party packages ================


# ================ Get MiniGUI packages ==================
# MiniGUI, MiniGUI components and samples, demos
# Now, mg-test only for intel cpu, so do not compile it.
for comp in minigui-res minigui mgutils mgplus mgeff mgncs mgncs4touch mg-samples mg-demos; do
    git clone $REPO_URL/$comp.git -b $BRANCH_NAME
done
# ================ Get MiniGUI packages ==================

# ================ Create root filesystem ================
mkdir ./rootfs
mkdir ./rootfs/etc
mkdir ./rootfs/usr
mkdir ./rootfs/usr/local
mkdir ./rootfs/usr/local/lib
mkdir ./rootfs/usr/local/include
mkdir ./rootfs/usr/local/etc
# ================ Create root filesystem ================
