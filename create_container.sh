#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Please pass the Image ID, e.g.: bash create_container.sh <IMAGE_ID>"
	exit 1
fi

LOG_DIR_HOST=/var/log/neutron
CONF_DIR_HOST=/etc/neutron
IMAGE_ID=$1
CONTAINER_NAME=neutron_ovs_agent

# Create log folder and grant permissions
mkdir -p $LOG_DIR_HOST
chmod -R 755 $LOG_DIR_HOST

# Create container
docker container create \
--network host \
--privileged \
--name $CONTAINER_NAME \
--restart unless-stopped \
-v /run/openvswitch:/run/openvswitch/ \
-v $LOG_DIR_HOST:/var/log/neutron \
-v $CONF_DIR_HOST:/etc/neutron \
-v /root/neutron_ovs_agent_launcher.sh:/neutron_ovs_agent_launcher.sh \
$IMAGE_ID \
bash /neutron_ovs_agent_launcher.sh

# Start container
docker start $CONTAINER_NAME
