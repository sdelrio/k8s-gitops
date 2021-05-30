#!/usr/bin/env sh

vault operator raft snapshot restore -force backup/snapshot

