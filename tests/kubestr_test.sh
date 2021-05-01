#!/bin/bash

# kubestr

CSI="
longhorn
longhorn-local-r1
longhorn-local-r2
longhorn-r1
longhorn-r2
longhorn-r3
"

NONCSI="
openebs-device
openebs-hostpath
"

## FIO test
for i in $CSI; do 
  echo kubestr fio -s $i
done

for i in $NONCSI; do 
  echo kubestr fio -s $i
done


## To check a CSI drivers snapshot and restore capabilities -
#for i in $NONCSI; do 
#  echo kubestr csicheck -s $i -v openebs-snapshot-promoter
#done


