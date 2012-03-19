#!/bin/bash

# Script to build for the htc pyramid and zip the package.
# Written by vorbeth

CCOMPILER=~/android/OpenSensation/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-

make ARCH=arm CROSS_COMPILE=$CCOMPILER clean
make ARCH=arm CROSS_COMPILE=$CCOMPILER pyramid_defconfig
make ARCH=arm CROSS_COMPILE=$CCOMPILER -j`grep 'processor' /proc/cpuinfo | wc -l`

if [ -e ./releasetools/system/lib/modules ]; then
 rm -rf ./releasetools/system/lib/modules
fi

mkdir -p ./releasetools/system/lib/modules

for i in `find drivers -name "*.ko"`; do
 cp $i ./releasetools/system/lib/modules/
done

if [ -e ./releasetools/kernel/zImage ]; then
 rm -f ./releasetools/kernel/zImage
fi

cp arch/arm/boot/zImage ./releasetools/kernel/

rm -f *.zip

cd releasetools

zip -r ../kernel-OpenSensation *
cd ..
echo "Finished"
