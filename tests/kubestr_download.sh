#!/bin/sh

VERSION=0.4.16
wget -c https://github.com/kastenhq/kubestr/releases/download/v$VERSION/kubestr-v$VERSION-linux-amd64.tar.gz -O - | tar -xz -C $HOME/.local/bin kubestr

