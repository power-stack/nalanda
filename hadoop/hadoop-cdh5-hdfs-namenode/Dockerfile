FROM hadoop-cdh5-base:0.0.1
MAINTAINER David Geng <david.geng@idevops.net>

# Install HDFS Namenode
RUN yum clean all; yum install -y hadoop-hdfs-namenode

RUN alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.empty 50
RUN alternatives --set hadoop-conf /etc/hadoop/conf.empty

# Configure hadoop
ADD files/core-site.xml.template /etc/hadoop/conf/core-site.xml.template
ADD files/hdfs-site.xml /etc/hadoop/conf/hdfs-site.xml

# hdfs dir
VOLUME /var/lib/hadoop-hdfs/cache/hdfs/dfs/name

EXPOSE 50020 50090 50070 50010 50075 8020 8031 8032 8033 8040 8042 49707 22 8088 8030


