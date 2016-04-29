#!/bin/sh

cd "openssl-${VERSION}"

export NDK=/usr/local/android-ndk
$NDK/build/tools/make-standalone-toolchain.sh --platform=android-14 --toolchain=arm-linux-androideabi-4.8 --install-dir=${WORKDIR}/android-toolchain-arm
export TOOLCHAIN_PATH=${WORKDIR}/android-toolchain-arm/bin
export TOOL=arm-linux-androideabi
export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
export CC=$NDK_TOOLCHAIN_BASENAME-gcc
export CXX=$NDK_TOOLCHAIN_BASENAME-g++
export LINK=${CXX}
export LD=$NDK_TOOLCHAIN_BASENAME-ld
export AR=$NDK_TOOLCHAIN_BASENAME-ar
export RANLIB=$NDK_TOOLCHAIN_BASENAME-ranlib
export STRIP=$NDK_TOOLCHAIN_BASENAME-strip
export ARCH_FLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
export ARCH_LINK="-march=armv7-a -Wl,--fix-cortex-a8"
export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export LDFLAGS=" ${ARCH_LINK} "

./Configure --openssldir=${OUTPUT_ARMV7} android-armv7
PATH=$TOOLCHAIN_PATH:$PATH
make
make install
rm ${WORKDIR}/openssl-${VERSION}/libcrypto.a ${WORKDIR}/openssl-${VERSION}/libssl.a 
if [ $? -ne 0 ]; then
  exit 1
fi


find . -type f -name "*.o" | xargs rm -rf {}

cd ..

