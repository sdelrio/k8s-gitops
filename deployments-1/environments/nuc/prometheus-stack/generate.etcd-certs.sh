#!/bin/bash

# Execute from RKE master node

sudo kubectl -n monitoring create secret generic etcd-certs \
  --from-file=ca.crt=/etc/kubernetes/ssl/kube-ca.pem \
  --from-file=etcd.pem=/etc/kubernetes/ssl/kube-etcd-10-6-3-201.pem \
  --from-file=etcd-key.pem=/etc/kubernetes/ssl/kube-etcd-10-6-3-201-key.pem

