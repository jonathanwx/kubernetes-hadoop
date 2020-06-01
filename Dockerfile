FROM openjdk:8u232-jdk

LABEL maintainer="jonathanlichi@gmail.com"
ARG HADOOP_VERSION=2.9.2
WORKDIR /tmp

# change apt source
# uncomment if needed
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
#   echo "deb http://mirrors.163.com/debian/ stretch main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian/ stretch-backports main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch-updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch-backports main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib">>/etc/apt/sources.list 

RUN apt-get update && apt-get install -y wget iputils-ping lsof

# alternative mirror site replace if needed
# RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN tar -xzvf hadoop-${HADOOP_VERSION}.tar.gz -C / && mv /hadoop-${HADOOP_VERSION} /hadoop

# fix bugs  https://help.aliyun.com/noticelist/articleid/1060035134.html
RUN rm -rf /hadoop/share/hadoop/hdfs/lib/jackson-annotations-2.7.8.jar /hadoop/share/hadoop/hdfs/lib/jackson-core-2.7.8.jar /hadoop/share/hadoop/hdfs/lib/jackson-databind-2.7.8.jar
RUN wget -P /hadoop/share/hadoop/hdfs/lib https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.9.10.4/jackson-databind-2.9.10.4.jar
RUN wget -P /hadoop/share/hadoop/hdfs/lib https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.9.10/jackson-annotations-2.9.10.jar
RUN wget -P /hadoop/share/hadoop/hdfs/lib https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.9.10/jackson-core-2.9.10.jar

COPY conf/* /hadoop/etc/hadoop/
COPY scripts/start.sh /
RUN chmod +x /start.sh

# change time zone
RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
# name node 
EXPOSE 50070 50470 8020 50090
# datanode
EXPOSE 50010 50075 50475 50020
# resource manager
EXPOSE 8030 8031 8032 8033 8088
# node manager
EXPOSE 8040 8042 8041
# history server
EXPOSE 10020 19888
# zkfc
EXPOSE 8019
# journal node
EXPOSE 8485 8480

RUN rm -rf /tmp
WORKDIR /
ENTRYPOINT ["/start.sh"]