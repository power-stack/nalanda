FROM centos:6.6
MAINTAINER David Geng <genggjh@hotmail.com>

ENV http_proxy http://9.115.78.100:8085
ENV https_proxy http://9.115.78.100:8085

# Add CDH repo
ADD files/hadoop-cdh5.repo /etc/yum.repos.d/
RUN rpm --import http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
RUN yum clean all

# Install java
RUN yum install -y java-1.7.0-openjdk

# INSTALL SUPERVISORD
RUN yum install -y python-setuptools \
&& easy_install pip \
&& pip install supervisor \
&& mkdir /etc/supervisord.d/ \
&& mkdir -p /conf/init

# ADD SUPERVISORD CONFS
ADD files/supervisord.conf /etc/supervisord.conf

ADD files/startup.sh /conf/
RUN chmod +x /conf/startup.sh

ONBUILD ADD files/supervisord.d/* /etc/supervisord.d/
ONBUILD ADD files/init/* /conf/init/

ENTRYPOINT /conf/startup.sh

