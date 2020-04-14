#!/bin/bash

kubectl delete -f hadoop-configmap.yaml
kubectl delete -f hadoop-datanode.yaml
kubectl delete -f hadoop-namenode.yaml
kubectl delete -f hadoop-secondarynamenode.yaml
# kubectl delete -f hadoop-resourcemanager.yaml
# kubectl delete -f hadoop-nodemanager.yaml