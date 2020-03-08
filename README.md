# Building MiniGUI 5.0

This repo contains some scripts to fetch and build MiniGUI 5.0.x

This instruction assumes that you are using Ubuntu Linux 18.04 LTS.

- [Current Status](#current-status)
   + [TODO list](#todo-list)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
   + [Options for build-minigui.sh script](#options-for-build-miniguish-script)
   + [Notes for demos](#notes-for-demos)
- [Commands to build dependencies](#commands-to-build-dependencies)
- [Change Log](#change-log)
- [Copying](#copying)
   + [Special Statement](#special-statement)
   + [Other Notes](#other-notes)

## Current Status

Currently, MiniGUI 5.0 is under development. This is the first preview
release of MiniGUI 5.0.0. The actual version number is 4.9.0.

Main enhancements of MiniGUI Core and its components are as follow:

- MiniGUI Core:
   - Support for compositing schema under MiniGUI-Processes runtime mode.
     This feature brings the exciting visual effects which are popular
     on modern desktop computers or smart phones to MiniGUI.
   - New main window types/levels. You now can easily create main windows
     in different z-order levels. This enhancement allows us to create
     a special app which acts as screen lock, docker, or launcher.
   - Virtual Window. You now can easily create message threads under all
     runtime modes to exploit the messaging mechanism of MiniGUI in
     non GUI threads - we call them message threads.
   - Enhanced timer support. MiniGUI now manages the timers per message thread.
     Under MiniGUI-Threads runtime mode, you can set up 32 (64 on 64-bit
     architecture) timers for each GUI threads. If you enabled virtual window,
     you can also do this for each message thread.
   - Support for listening a file descriptor as long as the underlying system
     has the `select()` system call for all runtime modes. Now you can call
     `RegisterListenFD()` to register a file descriptor to be listened, and
     handle `MSG_FDEVENT` in your window callback procedure to read/write
     from/to the file descriptor. Before this version, this feature only
     available for MiniGUI-Processes runtime mode.
   - Support for local data of windows. You can now set or retrieve a local data
     which is bound with a string name for a window. This will give you an
     eays-to-use interface to manage various data of a window.
   - Support for hardware cursors under compositing schema. MiniGUI now can
     utilize the hardware cursors if your graphics device support it.
     You can also load a cursor from a PNG file.
   - Support for loading icon from a bitmap file. You can now load an icon
     from a bitmap file such as a PNG file.
   - Unified the message hook functions for all runtime modes. MiniGUI now
     provides the consistent message hook functions for all runtime modes.
   - Use the update regions for cumulative updating the screen. This will
     emilinate the flickers due to the frequently redrawning of controls.
   - Cleaned up a lot of internal symbols (the external functions and
     global variables) in order to avoid name polution.
   - Refactored the code for the following modules: z-order management,
     message queue, event/message handling, and part of graphics abstract
     layer.
   - Some new APIs.
   - For more information, please refer to:
     <https://github.com/VincentWei/minigui/blob/dev-4-1/RELEASE-NOTES.md>
- mGEff, mGUtils, mGPlus, and mGNCS
   - Tune code for MiniGUI 5.0.0 or later.
   - Cleanup code for bad symbols.
- mGNCS4Touch
   - Tune code to comply with MiniGUI 5.0.0 and mGEff 1.5.0.
   - Tune the speed meter.
   - Enhance `ScrollViewPiece` and `HScrollViewPiece`.
- mg-tests:
   - Add new test programs for MiniGUI 5.0.0 in `5.0/` directory.

### TODO list

Before we release the official version 5.0.0, there are still some new
features to develop:

- Enhance DRM GAL engines to support MiniGUI-Processes runtime mode
  and compositing schema.
- Adjust common GAL engines to support compositing schema.
- A sample compositor with animation.
- More test programs for new features and new APIs.

## Prerequisites

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
* Dependent libraries:
   * libgtk2.0-dev
   * libjpeg-dev
   * libpng-dev (libpng12-dev on Ubuntu Linux 16.04 instead)
   * libfreetype6-dev
   * libinput-dev
   * libdrm-dev
   * libsqlite3-dev
   * libxml2-dev
   * libssl1.0-dev

You can run the following commands to install all above software packages on Ubuntu 18.04:

```
$ sudo apt install git g++ binutils autoconf automake libtool make cmake pkg-config
$ sudo apt install libgtk2.0-dev libjpeg-dev libpng-dev libfreetype6-dev
$ sudo apt install libinput-dev libdrm-dev libsqlite3-dev libxml2-dev libssl1.0-dev
```

Note that the `libgtk2.0-dev` packages is used by the virtual frame buffer program `gvfb`.

## Steps

Please make sure that you can visit GitHub and you can do `sudo` on your Linux box.

1. Copy `config.sh` to `myconfig.sh` and edit `myconfig.sh` to match your needs:

    $ cp config.sh myconfig.sh

1. Run `fetch-all.sh` to fetch all source from GitHub:

    $ ./fetch-all.sh

1. Run `build-deps.sh` to build and install gvfb, chipmunk, and harfbuzz:

    $ ./build-deps.sh

1. Run `build-all.sh` to build all:

    $ ./build-minigui.sh

1. Run `mguxdemo`:

    $ cd cell-phone-ux-demo/
    $ ./mginit

When there were some updates in the remote repos, you can run `update-all.sh` to
update them. You can run `clean-all.sh` to uninstall and clean them.

Note that you might need to run `ldconfig` to refresh the shared libraries cache
before running `mguxdemo` or other MiniGUI applications.

### Options for build-minigui.sh script

You can pass some options to `build-minigui.sh` script to specify the
compile-time configuration options of MiniGUI Core.

If you did not specify the options, it will use the following default options:

    procs compositing virtualwindow

The options above means:

- `procs`: build MiniGUI runs under MiniGUI-Processes runtime mode.
- `compositing`: build MiniGUI to use compositing schema.
- `virtualwindow`: enable virtual window.

The script uses a simple method for the traditional autoconf options:

- The first options always specifies the runtime mode of MiniGUI, you should
  choose one from `procs`, `ths`, or `sa`, which represent MiniGUI-Processes,
  MiniGUI-Threads, and MiniGUI-Standalone runtime modes respectively.
- If you specify an option with a prefix `-`, the feature will be disabled;
  otherwise it is enabled.

For example, if you want to build MiniGUI as standalone runtime mode and
without support for cursor, you can use the following command:

    $ ./build-minigui.sh sa -cursor

### Notes for demos

Note that if you configured MiniGUI other than MiniGUI-Processes runtime mode,
please use the following commands to run `mguxdemo`

```
$ cd cell-phone-ux-demo/
$ ./mguxdemo
```

For the sample of compisiting schema, please refer to `mg-tests`:

```
$ cd mg-tests/compositing/
$ ./mginit welcome
```

or

```
$ cd mg-tests/compositing/
$ ./mginit auto
```

You can also run other samples, demos, or test programs in `mg-samples`,
`mg-demos` or `mg-tests`.

## Commands to build dependencies

The following steps are those ones in `build-deps.sh`. We list them here just
for your information:

1. Make and install `gvfb`:

```
$ cd gvfb
$ cmake .
$ make; sudo make install
$ cd ..
```

1. Make and install `chipmunk` library (DO NOT use the chipmunk-dev package
   which is provided by Ubuntu):

```
$ cd 3rd-party/chipmunk
$ cmake .
$ make; sudo make install
$ cd ../..
```

1. Make and install `harfbuzz` library (DO NOT use the harfbuzz-dev package
   which is provided by Ubuntu):

```
$ cd 3rd-party/harfbuzz
$ ./autogen.sh
$ ./config-extern.sh
$ make; sudo make install
$ cd ../..
```

## Change Log

Currently, this repo just includes some scripts to build MiniGUI 5.0.x
core, components, and demonstration apps.

## Copying

Copyright (C) 2020 Beijing FMSoft Technologies Co., Ltd.

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

### Special Statement

The above open source or free software license does
not apply to any entity in the Exception List published by
Beijing FMSoft Technologies Co., Ltd.

If you are or the entity you represent is listed in the Exception List,
the above open source or free software license does not apply to you
or the entity you represent. Regardless of the purpose, you should not
use the software in any way whatsoever, including but not limited to
downloading, viewing, copying, distributing, compiling, and running.
If you have already downloaded it, you MUST destroy all of its copies.

The Exception List is published by FMSoft and may be updated
from time to time. For more information, please see
<https://www.fmsoft.cn/exception-list>.

### Other Notes

Also note that the software in `3rd-party/` may use different licenses.
Please refer to the `LICENSE` or `COPYING` files in the source trees for more
information.

Note that the software fetched from remote repositories may use different
licenses.  Please refer to the `LICENSE` or `COPYING` files in the source
trees for more information.

