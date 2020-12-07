#!/bin/bash

INIT_REPLICAS=$(kubectl -n vault get sts vault -o=json | jq .status.replicas)
kubectl -n vault scale sts vault --replicas=0

REPLICAS=$(kubectl -n vault get sts vault -o=json | jq .status.replicas)
while [ $REPLICAS != 0 ]; do
  sleep 2
  echo "waiting for 0 replicas on statefulset vault. (Now $REPLICAS)"
  REPLICAS=$(kubectl -n vault get sts vault -o=json | jq .status.replicas)
done

for i in `seq 0 $(($INIT_REPLICAS - 1))`; do
  kubectl -n vault delete pvc data-vault-$i
done

kubectl -n vault scale sts vault --replicas=$INIT_REPLICAS
REPLICAS=$(kubectl -n vault get sts vault -o=json | jq .status.replicas)
while [ $REPLICAS != $INIT_REPLICAS ]; do
  sleep 2
  echo "waiting for $INIT_REPLICAS replicas on statefulset vault. (Now $REPLICAS)"
  REPLICAS=$(kubectl -n vault get sts vault -o=json | jq .status.replicas)
done

