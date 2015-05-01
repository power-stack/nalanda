#!/bin/bash

echo "Taking a nap, to allow weave network to properly set up.."
if [[ -n $CONTAINER_IF ]]; then
  echo "Lookup ip addr from container interface: $CONTAINER_IF .."
  until [ -n "$container_ip" ]
  do
    container_ip=$(ip addr show dev $CONTAINER_IF | grep 'inet ' | awk '{print $2}')
    sleep 2
  done
  echo "Container IP addr from SDN: $container_ip .."
  export MESOS_IP="${container_ip%%/*}"
  export MESOS_HOSTNAME=$MESOS_IP
  export MARATHON_HOSTNAME=$MESOS_IP
  echo "$MESOS_IP" > /etc/chronos/conf/hostname  
  echo "$MESOS_IP  $HOSTNAME
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters" > /etc/hosts

  cat /etc/hosts
fi;

echo "That was a good nap. Now to work..."
ls -la ./
chmod +x setup-spark-env.sh
./setup-spark-env.sh $HDFS_FS_HOST $HDFS_HTTP_HOST $SPARK_BIN_VERSION $SPARK_BIN_DOWNLOAD_URL $MESOS_NATIVE_LIB

