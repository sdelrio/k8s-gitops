velero restore get | grep ^sample-longhorn | cut -f1 -d' '| xargs -L1 velero restore delete --confirm
velero backup delete sample-longhorn --confirm
kubectl -n velero get resticrepository | grep ^sample-longhorn | cut -f1 -d' ' | xargs -L1 kubectl -n velero delete resticrepository
