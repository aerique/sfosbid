#!/bin/sh

URL="http://releases.sailfishos.org/sdk/"
FILES="installers/latest/Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2 \
       targets/Sailfish_OS-latest-Sailfish_SDK_Tooling-i486.tar.7z   \
       targets/Sailfish_OS-latest-Sailfish_SDK_Target-i486.tar.7z    \
       targets/Sailfish_OS-latest-Sailfish_SDK_Target-armv7hl.tar.7z \
       targets/Sailfish_OS-latest-Sailfish_SDK_Target-aarch64.tar.7z"

cd downloads

for FILE in ${FILES}; do
    echo "Downloading ${URL}$FILE..."
    curl -o $(basename $FILE) ${URL}${FILE}
done
