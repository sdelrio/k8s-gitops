#!/bin/bash
# Create a secret with gpg.asci keys

if [ "$1" == "nuc" ]; then
  KEY=$(gpg --export-secret-keys -a 5B474AE3C65A390FA6CBFCF7DB65028F0219327A | base64 -w0)
elif [ "$1" == "dev" ]; then
  KEY=$(gpg --export-secret-keys -a F1EF7F423DCC4848A9123A416E1F583D7AF0A362 | base64 -w0)
else 
  echo "$0 (nuc|dev)"
  exit 1
fi

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: gpg-asc
  namespace: argocd
type: Opaque
data:
  gpg.asc: ${KEY}
EOF

