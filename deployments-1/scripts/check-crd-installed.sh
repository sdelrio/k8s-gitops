#!/usr/bin/env sh

set +e -u # -e "Automatic exit from bash shell script on error"  -u "Treat unset variables and parameters as errors"


kubectl get crd "$1" >/dev/null 2>&1

if [ $? -eq 0 ]; then
  printf "true"
else
  sleep 5
  kubectl get crd "$1" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    printf "true"
  else
    printf "false"
  fi
fi

