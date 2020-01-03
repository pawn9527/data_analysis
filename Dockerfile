# create docker file by centos7 hadoop 2.7.3 hive 3.1.1
FROM ansible/centos7-ansible:stable

USER root

RUN yum clean all; \
    rpm --rebuilddb; \
    yum install -y curl which tar sudo openssh-server openssh-clients rsync

RUN yum update -y libselinux

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# java
RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-8u181-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'

RUN rpm -i jdk-8u181-linux-x64.rpm
RUN rm jdk-8u181-linux-x64.rpm

ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin
RUN rm /usr/bin/java && ln -s $JAVA_HOME/bin/java /usr/bin/java

# hadoop
RUN mkdir /opt/module
RUN curl -s https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz | tar -xz -C /opt/module/
RUN curl -s https://mirrors.tuna.tsinghua.edu.cn/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz | tar -xz -C /opt/module/

# 设置环境变量
ENV HADOOP_HOME=/opt/module/hadoop-2.7.7
ENV HIVE_HOME=/opt/module/apache-hive-3.1.2-bin
ENV PATH=$PATH:$HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HIVE_HOME/bin