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
    apt-get -y install -yq --no-install-recommends mesos marathon chronos unzip libsasl2-modules supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
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

ADD entrypoint.sh /entrypoint.sh
ADD supervisord.d/mesos.conf /tmp/
ADD supervisord.d/supervisord.conf /etc/supervisor/
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
