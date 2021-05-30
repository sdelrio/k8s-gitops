#!/usr/bin/env sh

mkdir -p backup
kubectl -n vault get secret vault-tls -o jsonpath="{.data.ca\.crt}" | base64 --decode > $PWD/vault-ca.crt

