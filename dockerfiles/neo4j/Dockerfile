FROM centos:jre8u5

MAINTAINER Yusuke Nomura <nomura_y@welmo.co.jp>

RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt &&\
    rpm -ivh http://apt.sw.be/redhat/el5/en/i386/rpmforge/RPMS/rpmforge-release-0.5.1-1.el5.rf.i386.rpm

RUN yum update -y
RUN yum install -y wget tar lsof monit

RUN wget http://dist.neo4j.org/neo4j-community-2.0.3-unix.tar.gz
RUN mkdir /usr/local/neo4j
RUN cd /usr/local/neo4j && tar xzf /neo4j-community-2.0.3-unix.tar.gz && ln -s neo4j-community-2.0.3 default

ENV PATH /usr/local/neo4j/default/bin:$PATH
RUN rm /neo4j*

ADD neo4j.monit /etc/monit.d/neo4j.monit
