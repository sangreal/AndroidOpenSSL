#!/bin/sh

cd "openssl-${VERSION}"

export NDK=/usr/local/android-ndk
$NDK/build/tools/make-standalone-toolchain.sh --platform=android-14 --toolchain=x86-4.8 --install-dir=${WORKDIR}/android-toolchain-x86
export TOOLCHAIN_PATH=${WORKDIR}/android-toolchain-x86/bin
export TOOL=i686-linux-android
export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
export CC=$NDK_TOOLCHAIN_BASENAME-gcc
export CXX=$NDK_TOOLCHAIN_BASENAME-g++
export LINK=${CXX}
export LD=$NDK_TOOLCHAIN_BASENAME-ld
export AR=$NDK_TOOLCHAIN_BASENAME-ar
export RANLIB=$NDK_TOOLCHAIN_BASENAME-ranlib
export STRIP=$NDK_TOOLCHAIN_BASENAME-strip
export ARCH_FLAGS="-march=i686 -msse3 -mstackrealign -mfpmath=sse"
export ARCH_LINK=
export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export LDFLAGS=" ${ARCH_LINK} "

./Configure --openssldir=${OUTPUT_X86} android-x86
PATH=$TOOLCHAIN_PATH:$PATH
make
make install
if [ $? -ne 0 ]; then
  exit 1
else
 rm ${WORKDIR}/openssl-${VERSION}/libcrypto.a ${WORKDIR}/openssl-${VERSION}/libssl.a 
fi


find . -type f -name "*.o" | xargs rm -rf {}

cd ..
