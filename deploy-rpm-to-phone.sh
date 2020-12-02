#!/bin/sh

if [ "$2" = "" ]; then
    echo "Usage: deploy-rpm-to-phone.sh CONTAINER-ID PATH-TO-RPM [PHONE-IP" \
         "[PHONE-USER]]"
    echo
    echo "    - CONTAINER-ID : ID of Docker container RPM resides in"
    echo "    -  PATH-TO-RPM : Path where RPM resides in Docker container"
    echo "    -     PHONE-IP : IP address of phone RPM needs to be copied to"
    echo
    echo "    Example: ./deploy-rpm-to-phone.sh 1d3e2e6ca306 /home/nemo/cppqml-sample/RPMS/cppqml-1.0-1.armv7hl.rpm 192.168.178.42 fordperfect"
    echo
    echo "    This script expects public key SSH access to PHONE-IP for" \
         "PHONE-USER."
    exit
fi

if [ "$3" = "" ]; then
    PHONE_IP=192.168.2.15
else
    PHONE_IP=$3
fi

if [ "$4" = "" ]; then
    PHONE_USER=nemo
else
    PHONE_USER=$4
fi

CONTAINER_ID=$1
PATH_TO_RPM=$2
RPM=$(basename $2)

docker cp ${CONTAINER_ID}:${PATH_TO_RPM} .
scp ${RPM} ${PHONE_USER}@${PHONE_IP}:
#ssh ${PHONE_USER}@${PHONE_IP} devel-su pkcon -y install-local ${RPM}
