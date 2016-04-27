#!/bin/sh

VERSION=1.0.2g

SSL_OUTPUT=`pwd`/output
OUTPUT_ARMV7=${SSL_OUTPUT}/armeabi-v7a
OUTPUT_ARM=${SSL_OUTPUT}/armeabi
OUTPUT_X86=${SSL_OUTPUT}/x86

WORKDIR=`pwd`

mkdir -p ${SSL_OUTPUT}
mkdir -p ${OUTPUT_ARMV7}
mkdir -p ${OUTPUT_ARM}
mkdir -p ${OUTPUT_X86}

if [ ! -e openssl-${VERSION}.tar.gz ]; then
  echo "Downloading openssl-${VERSION}.tar.gz"
  curl ${CURL_OPTIONS} -O https://www.openssl.org/source/openssl-${VERSION}.tar.gz
else
  echo "Using openssl-${VERSION}.tar.gz"
fi

if [ ! -d openssl-${VERSION} ]; then
  tar zxf "openssl-${VERSION}.tar.gz" -C .
fi

chmod u+x openssl-${VERSION}/Configure

echo '******************* begin to build ArmV7a ***************'
chmod a+x buildArmV7.sh
. ./buildArmV7.sh
echo '********************ArmV7a finished *********************'

echo '******************** begin to build ArmV5 ****************'
chmod a+x buildArm.sh
. ./buildArm.sh
echo '******************* ArmV5 finished ***********************'


echo '******************** begin to build X86 ****************'
chmod a+x buildX86.sh
. ./buildX86.sh
echo '******************** X86 finished *********************'


echo '******************** all finished, congrats !! ' ********************
