FROM centos

RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt &&\
    rpm -ivh http://apt.sw.be/redhat/el5/en/i386/rpmforge/RPMS/rpmforge-release-0.5.1-1.el5.rf.i386.rpm

RUN yum update -y
RUN yum install -y wget unzip gcc make tar which monit

RUN cd /tmp && wget http://jp.softether-download.com/files/softether/v4.06-9437-beta-2014.04.09-tree/Linux/SoftEther%20VPN%20Server/64bit%20-%20Intel%20x64%20or%20AMD64/softether-vpnserver-v4.06-9437-beta-2014.04.09-linux-x64-64bit.tar.gz
RUN cd /usr/local && tar xvzf /tmp/softether-vpnserver-v4.06-9437-beta-2014.04.09-linux-x64-64bit.tar.gz && cd vpnserver && (yes 1 | make)
RUN rm -rf /tmp/*

ENV PATH $PATH:/usr/local/vpnserver

ADD vpnserver.init /vpnserver.init
RUN vpnserver start &&\
    sleep 2 &&\
    vpncmd /SERVER localhost:5555 /IN vpnserver.init &&\
    rm /vpnserver.init

ADD vpnserver.monit /etc/monit.d/vpnserver.monit
