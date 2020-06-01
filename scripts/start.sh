#!/usr/bin/env bash

HOST=$(hostname -s)
DOMAIN=$(hostname -d)

function create_config() {
  /bin/cp /hadoop/etc/hadoop/core-site.xml.bak /hadoop/etc/hadoop/core-site.xml
  /bin/cp /hadoop/etc/hadoop/hdfs-site.xml.bak /hadoop/etc/hadoop/hdfs-site.xml
  /bin/cp /hadoop/etc/hadoop/log4j.properties.bak /hadoop/etc/hadoop/log4j.properties
  /bin/cp /hadoop/etc/hadoop/mapred-site.xml.bak /hadoop/etc/hadoop/mapred-site.xml
  /bin/cp /hadoop/etc/hadoop/yarn-site.xml.bak /hadoop/etc/hadoop/yarn-site.xml

  sed -i "s/HADOOP_NAMENODE_HOST/${HADOOP_NAMENODE_HOST}/g" /hadoop/etc/hadoop/core-site.xml
  sed -i "s/HADOOP_DFS_REPLICATION/${HADOOP_DFS_REPLICATION}/g" /hadoop/etc/hadoop/hdfs-site.xml  
  sed -i "s/HADOOP_NAMENODE_HOST/${HADOOP_NAMENODE_HOST}/g" /hadoop/etc/hadoop/hdfs-site.xml
  sed -i "s/HADOOP_SECONDRARY_NAMENODE_HOST/${HADOOP_SECONDRARY_NAMENODE_HOST}/g" /hadoop/etc/hadoop/hdfs-site.xml
  sed -i "s/HADOOP_NAMENODE_HOST/${HADOOP_NAMENODE_HOST}/g" /hadoop/etc/hadoop/yarn-site.xml
  # sed -i "s/HADOOP_RESOURCEMANAGER_HOST/${HADOOP_RESOURCEMANAGER_HOST}/g" /hadoop/etc/hadoop/yarn-site.xml
  sed -i "s/HADOOP_CURRENT_HOST/${HOST}/g" /hadoop/etc/hadoop/yarn-site.xml

}

function unrecognized_node_type() {
  echo "unrecognized node type"
  echo "available node type:namenode|secondarynamenode|datanode"
  echo "specific it as HADOOP_NODE_TYPE under spec.containers.env"
  exit 1
}

create_config

if [ "${HADOOP_NODE_TYPE}" != "" ]; then
  if [ "${HADOOP_NODE_TYPE}" == "namenode" ]; then
    if test ! -e "/hadoop/hdfs/name"; then
      /hadoop/bin/hadoop namenode -format
    fi
    /hadoop/bin/hdfs namenode
  elif [ "${HADOOP_NODE_TYPE}" == "datanode" ]; then
    /hadoop/bin/hdfs datanode
  elif [ "${HADOOP_NODE_TYPE}" == "secondarynamenode" ]; then
    /hadoop/bin/hdfs secondarynamenode
  # elif [ "${HADOOP_NODE_TYPE}" == "resourcemanager" ]; then
  #   /hadoop/bin/yarn resourcemanager
  # elif [ "${HADOOP_NODE_TYPE}" == "nodemanager" ]; then
  #   /hadoop/bin/yarn nodemanager
  else
    unrecognized_node_type
  fi
else
  unrecognized_node_type
fi
