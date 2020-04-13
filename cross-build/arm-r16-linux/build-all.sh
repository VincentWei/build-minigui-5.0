#!/bin/bash

source modify-this-config.sh 

# If you use r16 toolchain to compile kernel and some package, this is the rootfs of output.
PLATFORM_DIR=$TINA_DIR/out/astar-parrot

# It is the tool chain directory, we should use include library in it.
TOOLCHAIN_DIR=$TINA_DIR/prebuilt/gcc/linux-x86/arm/toolchain-sunxi-musl/toolchain

# It is other tool chain directory. Because of absence of some header files, we have to use it.
HEADER_DIR=$TINA_DIR/prebuilt/gcc/linux-x86/arm/toolchain-sunxi-glibc/toolchain/include

# It is the current directory.
WORK_DIR=$(pwd)

# change meson files before export variables.
cd $WORK_DIR/3rd-party/libinput-1.10.0
sudo patch -p1 < $WORK_DIR/libinput.patch
sed "s#current_path#$WORK_DIR#g" ../../libinput.txt > cross_compile.txt
meson --cross-file cross_compile.txt . builddir/ --prefix=$WORK_DIR/rootfs/usr/local --libdir=$WORK_DIR/rootfs/usr/local/lib

# export some system varibles 
export STAGING_DIR=$PLATFORM_DIR/staging_dir
export CC=$(which arm-openwrt-linux-gcc)
export CXX=$(which arm-openwrt-linux-muslgnueabi-g++)
export LD=$(which arm-openwrt-linux-muslgnueabi-ld)
export AR=$(which arm-openwrt-linux-muslgnueabi-ar)
export AS=$CC
export NM=$(which arm-openwrt-linux-muslgnueabi-nm)
export GCC=$(which arm-openwrt-linux-muslgnueabi-gcc)
export RANLIB=$(which arm-openwrt-linux-muslgnueabi-ranlib)
export STRIP=$(which arm-openwrt-linux-muslgnueabi-strip)
export OBJCOPY=$(which arm-openwrt-linux-muslgnueabi-objcopy)
export OBJDUMP=$(which arm-openwrt-linux-muslgnueabi-objdump)
export SIZE=$(which arm-openwrt-linux-muslgnueabi-size)
export PKG_CONFIG_PATH=$WORK_DIR/rootfs/usr/local/lib/pkgconfig
export PKG_CONFIG_LIBDIR=$WORK_DIR/rootfs/usr/local/lib/pkgconfig

# compile chipmunk
echo "================= 1/23: compiling chipmunk now ... ================="
cd $WORK_DIR/3rd-party/chipmunk
cmake -D CMAKE_INSTALL_PREFIX=$WORK_DIR/rootfs/usr/local -D CMAKE_BUILD_TYPE=Release .
make -j$NRJOBS
sudo make install
cd $WORK_DIR/rootfs/usr/local/include/chipmunk
sudo patch -p1 < $WORK_DIR/chipmunk.patch 
echo "================= 1/23: chipmunk is compiled ... ==================="

# compile zlib
echo "================= 2/23: compiling zlib now ... ====================="
cd $WORK_DIR/3rd-party/zlib-1.2.8
./configure --shared --prefix=$WORK_DIR/rootfs/usr/local/
make -j$NRJOBS
sudo make install
echo "================= 2/23: zlib is compiled ... ======================="

# compile jpeg 
echo "================= 3/23: compiling libjpeg now ... =================="
cd $WORK_DIR/3rd-party/jpeg-7
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " 
make -j$NRJOBS
sudo make install
echo "================= 3/23: libjpeg is compiled ... ===================="

# compile png 
echo "================= 4/23: compiling libpng now ... =================="
cd $WORK_DIR/3rd-party/libpng-1.6.36
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include -DZ_FIXED=4 "
make -j$NRJOBS
sudo make install
echo "================= 4/23: libjpeg is compiled ... ===================="

# compile freetype 
echo "================= 5/23: compiling libfreetype now ... =============="
cd $WORK_DIR/3rd-party/freetype-2.6.1
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " LIBPNG_CFLAGS="-I$WORK_DIR/rootfs/usr/local/include " LIBPNG_LIBS="-L$WORK_DIR/rootfs/usr/local/lib " ZLIB_CFLAGS="-I$WORK_DIR/rootfs/usr/local/include " ZLIB_LIBS="-L$WORK_DIR/rootfs/usr/local/lib "
make -j$NRJOBS
sudo make install
echo "================= 5/23: libfreetype is compiled ... ================"

# compile harfbuzz 
echo "================= 6/23: compiling libharfbuzz now ... =============="
cd $WORK_DIR/3rd-party/harfbuzz
./autogen.sh
./configure --with-exunicode=yes --with-ucdn=no --with-glib=no --with-gobject=no --with-icu=no --with-freetype=yes CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-"  --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-Wl,-rpath=$STAGING_DIR/target/lib:$STAGING_DIR/target/usr/lib:$WORK_DIR/rootfs/usr/local/lib "  CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include -I$WORK_DIR/rootfs/usr/local/include/freetype2 -I. " FREETYPE_CFLAGS="-I$WORK_DIR/rootfs/usr/local/include " FREETYPE_LIBS="-L$WORK_DIR/rootfs/usr/local/lib" LIBS="-lz -lbz2 -lpng -lfreetype"
make -j$NRJOBS
sudo make install
echo "================= 6/23: libharfbuzz is compiled ... ================"

# compile libdrm 
echo "================= 7/23: compiling libdrm now ... ==================="
cd $WORK_DIR/3rd-party/libdrm-2.4.99
./configure --disable-intel --disable-libkms --enable-udev --disable-radeon --disable-amdgpu --disable-nouveau --disable-vmwgfx --disable-freedreno --disable-vc4 --enable-cairo-tests=no --enable-manpages=no CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-"  --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib "  CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include  "
make -j$NRJOBS
sudo make install
cd $WORK_DIR/rootfs/usr/local/include
ln -s libdrm/ drm
echo "================= 7/23: libdrm is compiled ... ====================="

# compile libmtdev 
echo "================= 8/23: compiling libmtdev now ... ================="
cd $WORK_DIR/3rd-party/mtdev-1.1.4
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-"  --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib "  CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include  "
make -j$NRJOBS
sudo make install
echo "================= 8/23: libmtdev is compiled ... ==================="

# compile kmoddev 
echo "================= 9/23: compiling kmoddev now ... =================="
cd $WORK_DIR/3rd-party/kmod-26
./autogen.sh
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-"  --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux --sysconfdir=$WORK_DIR/rootfs/etc --libdir=$WORK_DIR/rootfs/usr/local/lib LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-g -O2 -Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib "  CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include  "
make -j$NRJOBS
sudo make install
echo "================= 9/23: kmoddev is compiled ... ===================="

# compile libblkid-dev 
echo "================= 10/23: compiling libblkid-dev now ... ============"
cd $WORK_DIR/3rd-party/util-linux-2.31.1
./autogen.sh
./configure --disable-all-programs --enable-libblkid --enable-libuuid CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-"  --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux --sysconfdir=$WORK_DIR/rootfs/etc --libdir=$WORK_DIR/rootfs/usr/local/lib LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-g -O2 -Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib "  CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include  "
make -j$NRJOBS
sudo make install
echo "================= 10/23: libblkid-dev is compiled ... ==============="

# compile libudev 
echo "================= 11/23: compiling libudev now ... =================="
cd $WORK_DIR/3rd-party/udev-182
./configure --with-pci-ids-path=/tmp --disable-gtk-doc --disable-gtk-doc-html --enable-gtk-doc-pdf=no --enable-debug=no --disable-logging --disable-manpages --disable-gudev --disable-introspection --disable-keymap --disable-mtd_probe --enable-floppy=no --disable-keymap --enable-rule_generator=no  CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-"  --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib "  CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include  " USBUTILS_CFLAGS="-I$WORK_DIR/rootfs/usr/local/include " USBUTILS_LIBS="-L$WORK_DIR/rootfs/usr/local/lib " GLIB_CFLAGS="-I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include  " GLIB_LIBS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib "
make -j$NRJOBS
sudo make install
echo "================= 11/23: libudev is compiled ... ===================="

# compile libevdev 
echo "================= 12/23: compiling libevdev now ... ================="
cd $WORK_DIR/3rd-party/libevdev-1.8.0
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-"  --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib "  CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include  " 
make -j$NRJOBS
sudo make install
echo "================= 12/23: libevdev is compiled ... ==================="

# compile libinput 
echo "================= 13/23: compiling libinput now ... ================="
cd $WORK_DIR/3rd-party/libinput-1.10.0
ninja -C builddir/
sudo ninja -C builddir/ install
echo "================= 13/23: libinput is compiled ... ==================="

# compile libsqlite 
echo "================= 14/23: compiling libsqlite now ... ================"
cd $WORK_DIR/3rd-party/sqlite-autoconf-3310100
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-"  --prefix=$WORK_DIR/rootfs/usr/local/ --host="arm-openwrt-linux" --target=arm-openwrt-linux LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAG="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib "  CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include  " 
make -j$NRJOBS
sudo make install
echo "================= 14/23: libsqlite is compiled ... =================="

# compile minigui 
echo "================= 15/23: compiling libminigui now ... ==============="
cd $TOOLCHAIN_DIR/lib/gcc/arm-openwrt-linux-muslgnueabi/5.2.1/include
ln -s $HEADER_DIR/bits bits
ln -s $HEADER_DIR/error.h error.h
mkdir linux
cd linux
ln -s $TINA_DIR/lichee/linux-4.4/include/uapi/linux/input-event-codes.h input-event-codes.h
cd $WORK_DIR/rootfs/usr/local/lib
sudo ln -s libharfbuzzex.so.0.20501.0 libharfbuzz.so
cd $WORK_DIR/minigui
./autogen.sh
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --host="arm-openwrt-linux" --target=arm-openwrt-linux --build=x86_64-linux-gnu --program-prefix= --program-suffix= --prefix=$WORK_DIR/rootfs/usr/local --exec-prefix=$WORK_DIR/rootfs/usr/local --bindir=$WORK_DIR/rootfs/usr/local/bin --sbindir=$WORK_DIR/rootfs/usr/local/bin --libexecdir=$WORK_DIR/rootfs/usr/local/lib --sysconfdir=$WORK_DIR/rootfs/usr/local/etc --datadir=$WORK_DIR/rootfs/usr/local/share --localstatedir=$WORK_DIR/rootfs/var --mandir=$WORK_DIR/rootfs/usr/local/man --infodir=$WORK_DIR/rootfs/usr/local/info --disable-nls --with-runmode=ths --with-ttfsupport=ft2 --enable-develmode --enable-qpfsupport --enable-gb18030support --enable-ctrlstatic --enable-ctrlbutton --enable-ctrlsledit --enable-ctrlbidisledit --enable-ctrlnewtextedit --enable-ctrllistbox --enable-ctrlpgbar --enable-ctrlcombobox --enable-ctrlpropsheet --enable-ctrltrackbar --enable-ctrlscrollbar --enable-ctrlnewtoolbar --enable-ctrlmenubtn --enable-ctrlscrollview --enable-ctrltextedit --enable-ctrlmonthcal --enable-ctrltreeview --enable-ctrltreeview-rdr --enable-ctrlspinbox --enable-ctrlcoolbar --enable-ctrllistview --enable-ctrliconview --enable-ctrlgridview --enable-ctrlanimation --disable-splash --with-targetname=external --disable-videopcxvfb --enable-pngsupport --enable-jpgsupport LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib -lpng -lfreetype" CFLAGS="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib:$STAGING_DIR/target/usr/lib  " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " 
make -j$NRJOBS
sudo make install
echo "================= 15/23: libminigui is compiled ... ================="

# compile minigui-res 
echo "================= 16/23: compiling minigui-res now ... =============="
cd $WORK_DIR/minigui-res
./autogen.sh
./configure --build=x86_64-linux-gnu --program-prefix= --program-suffix= --prefix=$WORK_DIR/rootfs/usr/local --exec-prefix=$WORK_DIR/rootfs/usr/local --bindir=$WORK_DIR/rootfs/usr/local/bin --sbindir=$WORK_DIR/rootfs/usr/local/bin --libexecdir=$WORK_DIR/rootfs/usr/local/lib --sysconfdir=$WORK_DIR/rootfs/usr/local/etc --datadir=$WORK_DIR/rootfs/usr/local/share --localstatedir=$WORK_DIR/rootfs/var --mandir=$WORK_DIR/rootfs/usr/local/man --infodir=$WORK_DIR/rootfs/usr/local/info LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAGS="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib:$STAGING_DIR/target/usr/lib  " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " 
make -j$NRJOBS
sudo make install
echo "================= 16/23: minigui-res is compiled ... ================"

# compile mgutils 
echo "================= 17/23: compiling libmgutils now ... ==============="
cd $WORK_DIR/mgutils
./autogen.sh
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --target=arm-openwrt-linux --host=arm-openwrt-linux --build=x86_64-linux-gnu --program-prefix= --program-suffix= --prefix=$WORK_DIR/rootfs/usr/local --exec-prefix=$WORK_DIR/rootfs/usr/local --bindir=$WORK_DIR/rootfs/usr/local/bin --sbindir=$WORK_DIR/rootfs/usr/local/bin --libexecdir=$WORK_DIR/rootfs/usr/local/lib --sysconfdir=$WORK_DIR/rootfs/usr/local/etc --datadir=$WORK_DIR/rootfs/usr/local/share --localstatedir=$WORK_DIR/rootfs/var --mandir=$WORK_DIR/rootfs/usr/local/man --infodir=$WORK_DIR/rootfs/usr/local/info --disable-nls LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAGS="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib:$STAGING_DIR/target/usr/lib  " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " MINIGUI_LIBS="-L$WORK_DIR/rootfs/usr/local/lib -lminigui_ths -ljpeg -lm -lfreetype "
make -j$NRJOBS
sudo make install
echo "================= 17/23: libminiguiutils is compiled ... ============"

# compile mgplus 
echo "================= 18/23: compiling libmgplus now ... ================"
cd $WORK_DIR/mgplus
./autogen.sh
./configure --enable-ft2support=yes CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --target=arm-openwrt-linux --host=arm-openwrt-linux --build=x86_64-linux-gnu --program-prefix= --program-suffix= --prefix=$WORK_DIR/rootfs/usr/local --exec-prefix=$WORK_DIR/rootfs/usr/local --bindir=$WORK_DIR/rootfs/usr/local/bin --sbindir=$WORK_DIR/rootfs/usr/local/sbin --libexecdir=$WORK_DIR/rootfs/usr/local/lib --sysconfdir=$WORK_DIR/rootfs/usr/local/etc --datadir=$WORK_DIR/rootfs/usr/local/share --localstatedir=$WORK_DIR/rootfs/var --mandir=$WORK_DIR/rootfs/usr/local/man --infodir=$WORK_DIR/rootfs/usr/local/info --disable-nls LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib -lpng" CFLAGS="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib:$STAGING_DIR/target/usr/lib  " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " MINIGUI_LIBS="-L$WORK_DIR/rootfs/usr/local/lib -lminigui_ths -ljpeg -lm -lpng -lfreetype "
make -j$NRJOBS
sudo make install
echo "================= 18/23: libmgplus is compiled ... =================="

# compile mgeff 
echo "================= 19/23: compiling libmgeff now ... ================="
cd $WORK_DIR/mgeff
./autogen.sh
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --target=arm-openwrt-linux --host=arm-openwrt-linux --build=x86_64-linux-gnu --program-prefix= --program-suffix= --prefix=$WORK_DIR/rootfs/usr/local --exec-prefix=$WORK_DIR/rootfs/usr/local --bindir=$WORK_DIR/rootfs/usr/local/bin --sbindir=$WORK_DIR/rootfs/usr/local/sbin --libexecdir=$WORK_DIR/rootfs/usr/local/lib --sysconfdir=$WORK_DIR/rootfs/usr/local/etc --datadir=$WORK_DIR/rootfs/usr/local/share --localstatedir=$WORK_DIR/rootfs/var --mandir=$WORK_DIR/rootfs/usr/local/man --infodir=$WORK_DIR/rootfs/usr/local/info --disable-nls LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAGS="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib:$STAGING_DIR/target/usr/lib  " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " MINIGUI_LIBS="-L$WORK_DIR/rootfs/usr/local/lib -lminigui_ths -ljpeg -lm -lfreetype "
make -j$NRJOBS
sudo make install
echo "================= 19/23: libmgeff is compiled ... ==================="

# compile mgncs
echo "================= 20/23: compiling libmgncs now ... ================="
cd $WORK_DIR/mgncs
./autogen.sh
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --target=arm-openwrt-linux --host=arm-openwrt-linux --build=x86_64-linux-gnu --program-prefix= --program-suffix= --prefix=$WORK_DIR/rootfs/usr/local --exec-prefix=$WORK_DIR/rootfs/usr/local --bindir=$WORK_DIR/rootfs/usr/local/bin --sbindir=$WORK_DIR/rootfs/usr/local/sbin --libexecdir=$WORK_DIR/rootfs/usr/local/lib --sysconfdir=$WORK_DIR/rootfs/usr/local/etc --datadir=$WORK_DIR/rootfs/usr/local/share --localstatedir=$WORK_DIR/rootfs/var --mandir=$WORK_DIR/rootfs/usr/local/man --infodir=$WORK_DIR/rootfs/usr/local/info --disable-nls LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAGS="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib:$STAGING_DIR/target/usr/lib  " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " MINIGUI_LIBS="-L$WORK_DIR/rootfs/usr/local/lib -lminigui_ths -ljpeg -lm -lfreetype " --disable-dbxml
make -j$NRJOBS
sudo make install
echo "================= 20/23: libmgncs is compiled ... ==================="

# compile mgncs4touch
echo "================= 21/23: compiling libmgncs4touch now ... ==========="
cd $WORK_DIR/mgncs4touch
./autogen.sh
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --target=arm-openwrt-linux --host=arm-openwrt-linux --build=x86_64-linux-gnu --program-prefix= --program-suffix= --prefix=$WORK_DIR/rootfs/usr/local --exec-prefix=$WORK_DIR/rootfs/usr/local --bindir=$WORK_DIR/rootfs/usr/local/bin --sbindir=$WORK_DIR/rootfs/usr/local/sbin --libexecdir=$WORK_DIR/rootfs/usr/local/lib --sysconfdir=$WORK_DIR/rootfs/usr/local/etc --datadir=$WORK_DIR/rootfs/usr/local/share --localstatedir=$WORK_DIR/rootfs/var --mandir=$WORK_DIR/rootfs/usr/local/man --infodir=$WORK_DIR/rootfs/usr/local/info --disable-nls LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAGS="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib:$STAGING_DIR/target/usr/lib  " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " MINIGUI_LIBS="-L$WORK_DIR/rootfs/usr/local/lib -lminigui_ths -ljpeg -lm -lfreetype -lharfbuzzex"
make -j$NRJOBS
sudo make install
echo "================= 21/23: libmgncs4touch is compiled ... ============="

# compile mg-samples
echo "================= 22/23: compiling mg-samples now ... ==============="
cd $WORK_DIR/mg-samples
./autogen.sh
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --target=arm-openwrt-linux --host=arm-openwrt-linux --build=x86_64-linux-gnu --program-prefix= --program-suffix= --prefix=$WORK_DIR/rootfs/usr/local --exec-prefix=$WORK_DIR/rootfs/usr/local --bindir=$WORK_DIR/rootfs/usr/local/bin --sbindir=$WORK_DIR/rootfs/usr/local/sbin --libexecdir=$WORK_DIR/rootfs/usr/local/lib --sysconfdir=$WORK_DIR/rootfs/usr/local/etc --datadir=$WORK_DIR/rootfs/usr/local/share --localstatedir=$WORK_DIR/rootfs/var --mandir=$WORK_DIR/rootfs/usr/local/man --infodir=$WORK_DIR/rootfs/usr/local/info --disable-nls LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAGS="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib:$STAGING_DIR/target/usr/lib  " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " MINIGUI_LIBS="-L$WORK_DIR/rootfs/usr/local/lib -linput -ldrm -lminigui_ths -ljpeg -lm -lfreetype -lharfbuzzex" DRM_CFLAGS="-I$WORK_DIR/rootfs/usr/local/include " DRM_LIBS="-L$WORK_DIR/rootfs/usr/local/lib "
make -j$NRJOBS
sudo make install
echo "================= 22/23: mg-tests is compiled ... ==================="

# compile mg-demos
echo "================= 23/23: compiling mg-demos now ... ================="
cd $WORK_DIR/mg-demos
./autogen.sh
./configure CROSS_COMPILE="arm-openwrt-linux-muslgnueabi-" --target=arm-openwrt-linux --host=arm-openwrt-linux --build=x86_64-linux-gnu --program-prefix= --program-suffix= --prefix=$WORK_DIR/rootfs/usr/local --exec-prefix=$WORK_DIR/rootfs/usr/local --bindir=$WORK_DIR/rootfs/usr/local/bin --sbindir=$WORK_DIR/rootfs/usr/local/sbin --libexecdir=$WORK_DIR/rootfs/usr/local/lib --sysconfdir=$WORK_DIR/rootfs/usr/local/etc --datadir=$WORK_DIR/rootfs/usr/local/share --localstatedir=$WORK_DIR/rootfs/var --mandir=$WORK_DIR/rootfs/usr/local/man --infodir=$WORK_DIR/rootfs/usr/local/info --disable-nls LDFLAGS="-L$WORK_DIR/rootfs/usr/local/lib -L$STAGING_DIR/target/usr/lib -L$STAGING_DIR/target/lib " CFLAGS="-Wl,-rpath=$WORK_DIR/rootfs/usr/local/lib:$STAGING_DIR/target/usr/lib  " CPPFLAGS="-I$WORK_DIR/rootfs/usr/local/include -I$STAGING_DIR/target/usr/include -I$TOOLCHAIN_DIR/usr/include -I$TOOLCHAIN_DIR/include " MINIGUI_LIBS="-L$WORK_DIR/rootfs/usr/local/lib -linput -ldrm -lminigui_ths -ljpeg -lm -lfreetype -lharfbuzzex" DRM_CFLAGS="-I$WORK_DIR/rootfs/usr/local/include " DRM_LIBS="-L$WORK_DIR/rootfs/usr/local/lib "
make -j$NRJOBS
sudo make install
echo "================= 23/23: mg-demos is compiled ... ==================="
