#!/bin/sh

# This script is for version which are below 7.46

VERSION=7.45.0

WORKDIR=`pwd`

NDKDIR=/usr/local/android-ndk
SSLDIR=${WORKDIR}/output/openssl

SSL_X86_INCLDIR=${SSLDIR}/x86/include
SSL_ARM_INCLDIR=${SSLDIR}/armeabi/include
SSL_ARMV7_INCLDIR=${SSLDIR}/armeabi-v7a/include

SSL_X86_LIBDIR=${SSLDIR}/x86/lib
SSL_ARM_LIBDIR=${SSLDIR}/armeabi/lib
SSL_ARMV7_LIBDIR=${SSLDIR}/armeabi-v7a/lib

OUTPUT_DIR=`pwd`/output/libcurl
OUTPUT_X86_DIR=${OUTPUT_DIR}/x86
OUTPUT_ARM_DIR=${OUTPUT_DIR}/armeabi
OUTPUT_ARMV7_DIR=${OUTPUT_DIR}/armeabi-v7a

mkdir -p ${OUTPUT_X86_DIR}
mkdir -p ${OUTPUT_ARM_DIR}
mkdir -p ${OUTPUT_ARMV7_DIR}

if [ ! -e curl-${VERSION}.tar.gz ]; then
  echo "Downloading curl-${VERSION}.tar.gz"
  curl -O https://curl.haxx.se/download/curl-${VERSION}.tar.gz
else
  echo "Using curl-${VERSION}.tar.gz"
fi

if [ ! -d curl-${VERSION} ]; then
  tar zxf "curl-${VERSION}.tar.gz" -C .
fi

cd curl-${VERSION}

echo '************ begin to build x86 libcurl ******** '
echo ${SSL_X86_INCLDIR}
export NDK=${NDKDIR}
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
export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -I${SSL_X86_INCLDIR}"
export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export LDFLAGS=" ${ARCH_LINK} -L${SSL_X86_LIBDIR}"

./configure --host=i686-linux-android --with-ssl --disable-shared --prefix=${OUTPUT_X86_DIR}  --enable-ipv6
make clean && make
make install
echo '************ end build x86 ****************'

echo '************ begin to build arm libcurl ******** '
export NDK=${NDKDIR}
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
export SYSROOT=$NDK/platforms/android-14/arch-arm/
export ARCH_FLAGS="-mthumb"
export ARCH_LINK=
export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -I${SSL_ARM_INCLDIR}"
export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export LDFLAGS=" ${ARCH_LINK} -L${SSL_ARM_LIBDIR}"
./configure --host=arm-linux-androideabi --with-ssl --disable-shared --prefix=${OUTPUT_ARM_DIR}  --enable-ipv6
make clean && make
make install
echo '************ end build arm **********'

echo '************ bengin to build armv7 libcurl *********'

export ARCH_FLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
export ARCH_LINK="-march=armv7-a -Wl,--fix-cortex-a8"
export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -I${SSL_ARMV7_INCLDIR}"
export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export LDFLAGS=" ${ARCH_LINK} -L${SSL_ARMV7_LIBDIR}"
PATH=$TOOLCHAIN_PATH:$PATH

./configure --host=arm-linux-androideabi --with-ssl --disable-shared --prefix=${OUTPUT_ARMV7_DIR}  --enable-ipv6
make clean && make
make install
echo '************ end build armv7 ************'
