FROM centos:latest

MAINTAINER Yusuke Nomura <nomura_y@welmo.co.jp>

# RUN yum update -y

ADD jre-8u5-linux-x64.tar.gz /tmp/java
RUN mkdir /usr/local/java
RUN cd /usr/local/java && cp -r /tmp/java/jre1.8.0_05 . && ln -s jre1.8.0_05 default
ENV JAVA_HOME /usr/local/java/default
ENV PATH $JAVA_HOME/bin:$PATH
RUN rm -rf /tmp/java
