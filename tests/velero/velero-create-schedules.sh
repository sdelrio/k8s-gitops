# TTL: 10d = 240h
velero create schedule daily-velero --schedule="32 12 * * *" --include-namespaces velero -l app.kubernetes.io/name=velero --ttl 240h0m0s

# TTL: 4 months 2880h
velero create schedule weekly-cert-manager --schedule="5 3 * * 4" --include-namespaces cert-manager -l kubernetes.io/instance=cert-manager --ttl 720h0m0s
velero create schedule weekly-cert-issuers --schedule="5 3 * * 4" --include-namespaces cert-manager -l release=cert-issuers --ttl 720h0m0s

# TTL: 1 month 720h
velero create schedule weekly-openebs --schedule="5 5 * * 5" --include-namespaces openebs -l app=openebs --ttl 720h0m0s
velero create schedule weekly-metallb --schedule="5 3 * * 4" --include-namespaces metallb-system --ttl 720h0m0s

