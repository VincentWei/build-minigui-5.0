# Cross Compile MiniGUI 5.0 on r16

This repo contains some scripts to fetch and build MiniGUI 5.0.x

This instruction assumes that you are using Ubuntu Linux 18.04 LTS.

- [Current Status](#current-status)
   + [Known issues](#known-issues)
   + [Upcoming features](#upcoming-features)
- [Building MiniGUI 5.0](#building-minigui-50)
   + [Prerequisites](#prerequisites)
   + [Building steps](#building-steps)
   + [Options for build-minigui.sh script](#options-for-build-miniguish-script)
   + [Notes for demos](#notes-for-demos)
   + [Commands to build dependencies](#commands-to-build-dependencies)
- [Change Log](#change-log)
- [Copying](#copying)
   + [Special Statement](#special-statement)
   + [Other Notes](#other-notes)


## Building MiniGUI 5.0 on R16

### Prerequisites

You should run `apt install <package_name>` to install the following packages
on your Ubuntu Linux.

* Building tools:
   * git
   * gcc/g++
   * binutils
   * autoconf/automake
   * libtool
   * make
   * cmake
   * pkg-config
   * meson
   * ninja
   * tools Kit for r16

* Dependent libraries:
    Some dependent libraries will be compiled with r16 tools kit, and others will
    be compiled with packages downloaded.

You can run the following commands to install all above software packages on Ubuntu 18.04:

```
$ sudo apt install git g++ binutils autoconf automake libtool make cmake pkg-config
$ sudo apt-get install meson
$ sudo apt-get install ninja
```

### Building steps

Please make sure that you can visit GitHub and you can do `sudo` on your Linux box.

1. Build your r16 System:

```
$ cd your-r16/tinav2.5
$ source ./build/envsetup.sh
$ lunch
   choose your develop board type.
$ make menuconfig
$ make
```

In this step, when you run command 'make menuconfig', your MUST select option:

```
choose Libraries -> SSL -> libopenssl, and select all options
choose Libraries -> libcurl, libxml2
```

DO NOT Choose:

```
choose Libraries -> libfreetype, libjpeg, libpng, zlib
```

After command "make", you will get the rootfs for r16, and libopenssl and libxml2 are 
inclusive.

1. Modify the file: modify-this-config.sh

In file modify-this-config.sh, there are some variables which will be used in cross
compile process. The only line you have to modify is:

```
TINA_DIR=/home/projects/r16/tinav2.5
```

You change this path according to your system.

The other line:

```
REPO_URL=https://gitlab.fmsoft.cn/VincentWei
```

You can modify with other url address, which download speed is high.


1. Run `fetch-all.sh` to fetch all source from GitHub:

```
$ ./fetch-all.sh
```

This script creates a directroy named "3rd-party", and packages will be downloaded
in this directory, and decompressed.


1. Run `build-all.sh` to build and install libraries:

```
$ ./build-all.sh
```

After cross compile, there is a directory named "rootfs", which stores all output 
libraries. You can copy the contents in this directory to your r16 rootfs, and in
your r16 path, use command:

```
$ pack -d
```

to make our r16 image files.

## Change Log

Currently, this repo just includes some scripts to build MiniGUI 5.0.x
core, components, and demonstration apps.

## Copying

Copyright (C) 2018 ~ 2020 Beijing FMSoft Technologies Co., Ltd.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
