FROM yaronr/debian-jessie
MAINTAINER gengjh

# Setup
# Mesos fetcher uses unzip to extract staged zip files
# for lsb, see http://affy.blogspot.co.il/2014/11/is-using-lsbrelease-cs-good-idea-inside.html
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    DISTRO=debian && \
    CODENAME=wheezy && \
    echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | tee /etc/apt/sources.list.d/mesosphere.list && \
    DEBIAN_FRONTEND=noninteractive apt-get -y update && \
    apt-get -y install -yq --no-install-recommends mesos && \
    rm /etc/mesos/zk && \
    rm /etc/mesos-master/quorum 

RUN echo "deb http://archive-primary.cloudera.com/cdh5/debian/wheezy/amd64/cdh wheezy-cdh5 contrib" | tee /etc/apt/sources.list.d/cdh5.list && \
    echo "deb-src http://archive-primary.cloudera.com/cdh5/debian/wheezy/amd64/cdh wheezy-cdh5 contrib" >> /etc/apt/sources.list.d/cdh5.list && \
    curl -s http://archive.cloudera.com/cdh5/debian/wheezy/amd64/cdh/archive.key | apt-key add - && \
    apt-get -y update && \
    apt-get -y install hadoop-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

#Ignore /etc/hosts. Resolve this host via DNS
RUN sed 's/^\(hosts:[\ ]*\)\(files\)\ \(dns\)$/\1\3 \2/' -i /etc/nsswitch.conf

ENV HDFS_FS_HOST hdfsnamenode:8020
ENV HDFS_HTTP_HOST hdfsnamenode:50070
ENV SPARK_BIN_VERSION 1.3.1-bin-cdh4
ENV SPARK_BIN_DOWNLOAD_URL http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_BIN_VERSION}.tgz
ENV MESOS_NATIVE_LIB /usr/lib/libmesos.so

WORKDIR /tmp/spark
RUN wget -O spark-${SPARK_BIN_VERSION}.tgz $SPARK_BIN_DOWNLOAD_URL && tar xzf spark-${SPARK_BIN_VERSION}.tgz
ADD deployment/ansible/files/setup-spark-env.sh /tmp/spark/
ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
