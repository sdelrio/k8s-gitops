#!/usr/bin/env sh

kubectl get crd |grep "vaults.vault.banzaicloud.com" |awk '{print $1}' | xargs kubectl delete crd

