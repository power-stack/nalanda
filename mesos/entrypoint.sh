#!/bin/bash

if [[ -n $MULTICLOUD_DNS && -n MULTICLOUD_DNS_SEARCH ]] ; then
  echo "Replacing /etc/resolv.conf with:"
  echo "nameserver $MULTICLOUD_DNS" 
  echo "search $MULTICLOUD_DNS_SEARCH"
  echo "nameserver $MULTICLOUD_DNS" > /etc/resolv.conf
  echo "search $MULTICLOUD_DNS_SEARCH" >> /etc/resolv.conf
fi;

echo "Taking a nap, to allow weave network to properly set up.."
sleep 10
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
mkdir -p /etc/supervisor/conf.d/
sed "s#COMMAND#$@#g;" /tmp/mesos.conf > /etc/supervisor/conf.d/mesos.conf
cat /etc/supervisor/conf.d/mesos.conf
supervisord -c /etc/supervisor/supervisord.conf -n
