#!/bin/bash

for comp in minigui-res mg-samples minigui mgutils mgplus mgeff mgncs mgncs4touch mg-tests mg-demos cell-phone-ux-demo; do
    echo
    echo "CHECKING STATUS IN $comp..."
    cd $comp
    git remote set-url origin git4os@gitlab.fmsoft.cn:VincentWei/$comp.git
    git remote add github git@github.com:VincentWei/$comp.git
    git remote add gitee git@github.com:vincentwei7/$comp.git
    cd ..
done
