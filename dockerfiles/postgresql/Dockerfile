FROM centos:latest

MAINTAINER Yusuke Nomura <nomura_y@welmo.co.jp>

RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt &&\
    rpm -ivh http://apt.sw.be/redhat/el5/en/i386/rpmforge/RPMS/rpmforge-release-0.5.1-1.el5.rf.i386.rpm

RUN yum update -y
RUN yum install -y postgresql-server monit
RUN service postgresql initdb
RUN (sed -e "s/#listen_addresses = 'localhost'\(.*\)/listen_addresses = '*'\1/" /var/lib/pgsql/data/postgresql.conf > /tmp/conf) && mv /tmp/conf /var/lib/pgsql/data/postgresql.conf
RUN echo host all all 0.0.0.0/0 trust >> /var/lib/pgsql/data/pg_hba.conf

Add postgresql.monit /etc/monit.d/postgresql.monit
