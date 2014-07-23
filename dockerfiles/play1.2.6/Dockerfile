FROM centos:jre8u5

RUN yum update -y
RUN yum install -y wget unzip

RUN cd /tmp && wget http://downloads.typesafe.com/play/1.2.7/play-1.2.7.zip
RUN mkdir /usr/local/play
RUN cd /usr/local/play && unzip /tmp/play-1.2.7.zip && ln -s play-1.2.7 default
ENV PATH /usr/local/play/default:$PATH
