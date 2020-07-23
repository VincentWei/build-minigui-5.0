#!/bin/bash

if [ ! -f myconfig.sh ]; then
    cp config.sh myconfig.sh
fi

source myconfig.sh

rm *.tar.[bg]z* -f

echo MAKE TARBALLS OF MINIGUI DOCS
for comp in minigui mgutils mgplus mgeff mgncs mgncs4touch; do
    cd $comp
    make docs
    for name in doc-*; do
        tar czf $name.tar.gz $name
        rm $name -rf
    done
    mv *.tar.gz ..
    cd ..
done

echo MAKE TARBALLS OF GVFB
cd gvfb
make package_source
mv *.tar.gz ..
cd ..

echo MAKE TARBALLS OF MINIGUI
for comp in minigui minigui-res mgutils mgplus mgeff mgncs mg-tests mg-samples mgncs4touch mg-demos cell-phone-ux-demo; do
    cd $comp
    make dist
    mv *.tar.gz ..
    cd ..
done

echo MAKE TARBALLS OF THIRD-PARTY PACKAGES
for comp in chipmunk; do
    cd 3rd-party/$comp
    make dist || make package_source
    mv *.tar.[xgb]z* ../..
    cd ../..
done

