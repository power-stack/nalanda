# Spark

## Introduction

This spark-shell environment is based on Docker container and will be used to connect to mesos master to run tasks.

The Vagrantfile is only for your development on physical machin since the virtualbox can not run on VM, before up
the vagrant you have to install the prerequisites manually.

## Run Spark-shell docker container

You need specify the environment variables like before to specify where is the HDFS

```
-e HDFS_HTTP_HOST=192.168.200.23:50070

-e HDFS_FS_HOST=192.168.200.23:8020
```

Run the docker container via provided script to assign a real IP address::

```
$ cd docker-scriptes
$ sudo ./docker-mesos-spark-shell eth0 eth1 spark-shell:0.0.1 192.168.200.9/24@192.168.200.1 192.168.200.23:8020 192.168.200.23:50070 mesos://zk://192.168.200.7:2181,192.168.200.7:2182,192.168.200.7:2183/mesos
$ sudo docker exec -it spark-shell bash
$ cd /tmp/spark/spark-1.3.1-bin-cdh4/bin
$ ./spark-shell
```

Now, the Spark REPL is ready, you can play it.

