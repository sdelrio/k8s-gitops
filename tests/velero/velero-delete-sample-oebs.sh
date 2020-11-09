velero restore get | grep ^sample-oebs | cut -f1 -d' '| xargs -L1 velero restore delete --confirm
velero backup delete sample-oebs --confirm
kubectl -n velero get resticrepository | grep ^sample-oebs | cut -f1 -d' ' | xargs -L1 kubectl -n velero delete resticrepository
