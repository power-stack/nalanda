# Spark

## Introduction

This spark environment is based on Docker container and will be used to connect to mesos master to run tasks.

The Vagrantfile is only for your development on physical machin since the virtualbox can not run on VM, before up
the vagrant you have to install the prerequisites manually.

## Build Spark docker container

Before build the Spark docker container, you need download the latest spark source code to build the distribution
package for your Hadoop version if you can find it.

Following are the procedure to build spark 1.3.1 for CDH5.4 Hadoop 2.6.0 version::

```
$ yum install -y java-1.7.0-openjdk-devel
$ wget http://www.apache.org/dyn/closer.cgi/spark/spark-1.3.1/spark-1.3.1.tgz && tar xzf spark-1.3.1.tgz
$ cd spark-1.3.1 && ./make-distribution.sh --skip-java-test --name spark-1.3.1-bin-cdh5.4-hadoop-2.6.0.tgz --tgz --with-tachyon -Phive -Phive-thriftserver -Pyarn -Dyarn.version=2.6.0 -Phadoop-2.4 -Dhadoop-2.6.0-cdh5.4.0
$ mv spark-1.3.1-bin-cdh5.4-hadoop-2.6.0.tgz ../ && cd ../
```

Build docker container with this distribution package

```
$ sudo docker build -t spark:0.0.1 --force-rm=true  ./
```

## Run Spark docker container

You need specify the environment variables like before to specify where is the HDFS

```
-e HDFS_HTTP_HOST=192.168.200.23:50070

-e HDFS_FS_HOST=192.168.200.23:8020
```

Run the docker container via provided script to assign a real IP address::

```
$ cd docker-scriptes
$ sudo ./docker-mesos-spark eth0 eth1 spark:0.0.1 192.168.200.9/24@192.168.200.1 192.168.200.23:8020 192.168.200.23:50070 mesos://zk://192.168.200.7:2181,192.168.200.7:2182,192.168.200.7:2183/mesos
$ sudo docker exec -it spark bash
$ cd /tmp/spark/spark-bin-cdh5.4-hadoop-2.6.0/bin
$ ./spark-shell
```

Now, the Spark REPL is ready, you can play it.

