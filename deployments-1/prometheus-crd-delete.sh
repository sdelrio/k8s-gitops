#!/bin/bash

kubectl get crd | grep monitoring.coreos |awk '{print $1}'| xargs kubectl delete crd

#kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
#kubectl delete crd alertmanagers.monitoring.coreos.com
#kubectl delete crd podmonitors.monitoring.coreos.com
#kubectl delete crd probes.monitoring.coreos.com
#kubectl delete crd prometheuses.monitoring.coreos.com
#kubectl delete crd prometheusrules.monitoring.coreos.com
#kubectl delete crd servicemonitors.monitoring.coreos.com
#kubectl delete crd thanosrulers.monitoring.coreos.com

