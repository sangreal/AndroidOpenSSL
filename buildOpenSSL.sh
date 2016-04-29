#!/bin/sh

VERSION=1.0.2g
WORKDIR=`pwd`

OUTPUT_ARMV7=${WORKDIR}/output/openssl/armeabi-v7a
OUTPUT_ARM=${WORKDIR}/output/openssl/armeabi
OUTPUT_X86=${WORKDIR}/output/openssl/x86

checkRet () {
  if [ $? -ne 0 ]; then
    exit 1
  fi
}

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

rm -rf ${OUTPUT_ARMV7}

chmod a+x buildArmV7.sh
. ./buildArmV7.sh
checkRet
echo '********************ArmV7a finished *********************'

echo '******************** begin to build ArmV5 ****************'

rm -rf ${OUTPUT_ARM}

chmod a+x buildArm.sh
. ./buildArm.sh
checkRet
echo '******************* ArmV5 finished ***********************'


echo '******************** begin to build X86 ****************'

rm -rf ${OUTPUT_X86}

chmod a+x buildX86.sh
. ./buildX86.sh
checkRet
echo '******************** X86 finished *********************'


echo '******************** all finished, congrats !! ********************'
