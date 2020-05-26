# 首届“暑期2020”项目说明

![SUMMER 2020](figures/summer-2020.webp)


本文是 MiniGUI 社区参与中科院软件所发起的首届“暑期2020”活动的项目说明。

## 面向小屏幕智能设备的 MiniGUI 定制合成器

【项目标题】面向小屏幕智能设备的 MiniGUI 合成器

【项目描述】自 MiniGUI 5.0 起，MiniGUI 的多进程模式开始支持合成图式（compositing schema）。合成图式是现代桌面操作系统和智能手机操作系统的图形及窗口系统使用的技术，其基本原理很简单：系统中所有进程创建的每一个窗口都使用独立的缓冲区来各自渲染其内容，而系统中有一个扮演合成器（compositor）角色的进程，负责将这些内容根据窗口的 Z 序以及叠加效果（如半透明、模糊等）合成在一起并最终显示在屏幕上。本项目要求为 MiniGUI 5.0 的合成图式开发一个适合于小屏幕智能设备的定制合成器，实现自定义的窗口层叠效果（如阴影、模糊、不规则窗口等），以及窗口的切换动画等效果。

【项目难度】高

【项目社区导师】魏永明

【导师联系方式】vincent@minigui.org

【项目产出要求】
   - 可在 Ubuntu 18.04 上编译运行，使用 HybridOS 图形栈中的 Cairo 或者 Mesa (OpenGL ES）作为渲染引擎，实现一个定制的 MiniGUI 5.0 合成器，可参考效果：
     - 智能手机。
     - 中高档轿车中的车载娱乐系统。
   - 可整合 mgdemo、mguxdemo 等 MiniGUI 已有示例程序或者演示程序中的代码。注：这些代码均以 Apache 2.0 许可证发布。

【项目技术要求】
   - Linux 环境下的 C/C++ 编程
   - MiniGUI、Cairo、OpenGL ES 等软件

【相关的开源软件仓库列表】
   - <https://github.com/VincentWei/build-minigui-5.0>
   - <https://github.com/FMSoftCN/hicairo>
   - <https://github.com/FMSoftCN/himesa>
  
## MiniGUI 的 DRM 加速图形引擎

【项目标题】MiniGUI 的 DRM 加速图形引擎

【项目描述】DRM 已经成为 Linux 环境中新一代的现代图形支持框架。自 4.0 版本以来，MiniGUI 支持 DRM，但目前只提供了一个针对早期 Intel i915 芯片的加速图形引擎。该项目要求您为某个支持 DRM 且包含基础 2D 加速能力的 GPU 开发一个 MiniGUI 的 DRM 加速图形引擎。该 GPU 可以是 PC 显卡，也可以是嵌入式 SoC，如全志、瑞芯或者展讯的 SoC。

【项目难度】中

【项目社区导师】魏永明

【导师联系方式】vincent@minigui.org

【项目产出要求】
   - 符合 MiniGUI 5.0 DRM 引擎接口的加速引擎，可编译成动态库供 MiniGUI 在运行时动态装载。
   - 提供对显存管理、矩形填充、位块传输（Blitting）等的加速支持。

【项目技术要求】
   - Linux 环境下的 C/C++ 编程
   - MiniGUI、Mesa 等软件

【相关的开源软件仓库列表】
   - <https://github.com/VincentWei/build-minigui-5.0>
   - <https://github.com/FMSoftCN/himesa>
  
## HybridOS 图形栈增强

【项目标题】HybridOS 图形栈增强

【项目描述】HybridOS 是飞漫软件正在开发中的针对物联网的新一代操作系统。飞漫软件已基于 MiniGUI、Mesa、Cairo 等开源软件发布了 HybridOS 图形栈。在 Mesa 的 MiniGUI Backend 实现中，目前未提供对 EGL pixel buffer 的支持。本项目要求在现有 Mesa MiniGUI backend 的实现基础上，提供对 EGL pixel buffer 的支持。

【项目难度】中

【项目社区导师】魏永明

【导师联系方式】vincent@minigui.org

【项目产出要求】
   - 在现有 Mesa MiniGUI backend 的实现基础上，提供符合 EGL 规范 pixel buffer 相关接口实现。

【项目技术要求】
   - Linux 环境下的 C/C++ 编程
   - MiniGUI、Mesa 等软件

【相关的开源软件仓库列表】
   - <https://github.com/VincentWei/build-minigui-5.0>
   - <https://github.com/FMSoftCN/himesa>
  
## MiniGUI 中文输入法增强

【项目标题】MiniGUI 中文输入法增强

【项目描述】MiniGUI 现有开源的中文输入法引擎已经过时了。本项目要求移植一个成熟的开源中文输入法引擎，使得 MiniGUI 应用可以获得更好的中文输入法支持。

【项目难度】低

【项目社区导师】魏永明

【导师联系方式】vincent@minigui.org

【项目产出要求】
   - 选择一款较为流行的开源中文输入法引擎移植到 MiniGUI 环境中。
   - 可在 Ubuntu Linux 5.0 环境中运行。

【项目技术要求】
   - Linux 环境下的 C/C++ 编程
   - MiniGUI

【相关的开源软件仓库列表】
   - <https://github.com/VincentWei/build-minigui-5.0>
   - <https://github.com/VincentWei/mg-demos>
  
## 参考文档

1. 项目标题：精简版的树莓派镜像
2. 项目描述：树莓派（英语：Raspberry Pi）是基于 Linux 的单片机电脑，目的是以低价硬件及自由软件促进学校的基本计算机科学教育。树莓派需要刷写文件系统镜像来实现启动，镜像文件常常都较大，不利于快速分发和安装，本项目目标是实现一个小于 NNN MB 的树莓派镜像，并能够通过 DNF 安装软件源中更多的软件进来。
3. 项目难度：高
4. 项目社区导师：姓名 或 ID
5. 导师联系方式：电子邮箱
6. 合作导师联系方式（选填）：ID或姓名，电子邮箱
7. 项目产出要求：
   - 小于 NNN MB 的树莓派镜像，该镜像可刷写在树莓派 Pi 4 上
   - 镜像中版本号信息
   - 镜像支持 DNF 安装软件源中的软件
8. 项目技术要求：
   - 基本的 Linux 命令
   - DNF/RPM 包管理
   - 具备一种脚本语言，如 Python、Bash script 等
   - 压缩算法
9. 相关的开源软件仓库列表：
   - https://gitee.com/openeuler/raspberrypi
   - https://gitee.com/openeuler/raspberrypi-kernel
