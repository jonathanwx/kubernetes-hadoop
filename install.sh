#!/bin/bash

kubectl apply -f hadoop-configmap.yaml
kubectl apply -f hadoop-namenode.yaml
kubectl apply -f hadoop-secondarynamenode.yaml
kubectl apply -f hadoop-datanode.yaml
# kubectl apply -f hadoop-resourcemanager.yaml
# kubectl apply -f hadoop-nodemanager.yaml