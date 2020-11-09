velero restore get |grep ^sample-app|cut -f1 -d' '|xargs -L1 velero restore delete --confirm
velero backup delete sample-app --confirm

