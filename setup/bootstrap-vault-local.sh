#!/bin/bash
#set -e
#set -x
# trap "exit" INT TERM
# trap "kill 0" EXIT

export REPO_ROOT=$(git rev-parse --show-toplevel)
export REPLICAS="0 1 2"

need() {
    if ! command -v "$1" &> /dev/null
    then
        echo "Binary '$1' is missing but required"
        exit 1
    fi
}

need "kubectl"
need "sed"
need "jq"

if [ ! -f "$REPO_ROOT"/setup/.env ]; then
  cp "$REPO_ROOT"/setup/.env.sample "$REPO_ROOT"/setup/.env
fi

. "$REPO_ROOT"/setup/.env

message() {
  LEVEL=0
  if [ $2 ]; then
      LEVEL=$2
  fi

  if [ "$2" == "1" ]; then
    echo -n " + "
  elif [ "$2" == "2" ]; then
    echo -n "  > "
  else
    echo -n "* "
  fi
  echo "$1"
}

initVault() {
  message "Initializing and unsealing vault (if necesary)"
  VAULT_READY=1
  while [ $VAULT_READY != 0 ]; do
    kubectl -n $NAMESPACE wait --for condition=Initialized pod/vault-0 > /dev/null 2>&1
    VAULT_READY="$?"
    if [ $VAULT_READY != 0 ]; then 
      message "waiting for vault pod to be somewhat ready..." 2
      sleep 10; 
    fi
  done
  sleep 2

  VAULT_READY=1
  while [ $VAULT_READY != 0 ]; do
    init_status=$(kubectl -n $NAMESPACE exec "vault-0" -- vault status -format=json 2>/dev/null | jq -r '.initialized')
    if [ "$init_status" == "false" ] || [ "$init_status" == "true" ]; then
      VAULT_READY=0
    else
      message "vault pod is almost ready, waiting for it to report status" 2
      sleep 5
    fi
  done

  sealed_status=$(kubectl -n $NAMESPACE exec "vault-0" -- vault status -format=json 2>/dev/null | jq -r '.sealed')
  init_status=$(kubectl -n $NAMESPACE exec "vault-0" -- vault status -format=json 2>/dev/null | jq -r '.initialized')

  if [ "$init_status" == "false" ]; then
    message "initializing vault" 1
    vault_init=$(kubectl -n $NAMESPACE exec "vault-0" -- vault operator init -format json -key-shares=1 -key-threshold=1) || exit 1
    
    export VAULT_UNSEAL_TOKEN=$(echo $vault_init | jq -r '.unseal_keys_b64[0]')
    export VAULT_ROOT_TOKEN=$(echo $vault_init | jq -r '.root_token')

    # sed -i operates differently in OSX vs linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # darwin system
        sed -i '' "s~VAULT_ROOT_TOKEN=\".*\"~VAULT_ROOT_TOKEN=\"$VAULT_ROOT_TOKEN\"~" "$REPO_ROOT"/setup/.env
        sed -i '' "s~VAULT_UNSEAL_TOKEN=\".*\"~VAULT_UNSEAL_TOKEN=\"$VAULT_UNSEAL_TOKEN\"~" "$REPO_ROOT"/setup/.env
    else
        # linux system
        sed -i'' "s~VAULT_ROOT_TOKEN=\".*\"~VAULT_ROOT_TOKEN=\"$VAULT_ROOT_TOKEN\"~" "$REPO_ROOT"/setup/.env
        sed -i'' "s~VAULT_UNSEAL_TOKEN=\".*\"~VAULT_UNSEAL_TOKEN=\"$VAULT_UNSEAL_TOKEN\"~" "$REPO_ROOT"/setup/.env
    fi
    message "SAVED VALUES INTO $REPO_ROOT/setup/.env" 2

    FIRST_RUN=0
  fi

  sealed_status=$(kubectl -n $NAMESPACE exec "vault-0" -- vault status -format=json 2>/dev/null | jq -r '.sealed')
  if [ "$sealed_status" == "true" ]; then
    sleep 1
    message "Unsealing vault-0" 1
    kubectl -n $NAMESPACE exec "vault-0" -- vault operator unseal "$VAULT_UNSEAL_TOKEN" >/dev/null || exit 1
  fi

  PEER_READY=1
  message "Waiting first vault to be ready" 1
  while [ $PEER_READY != 0 ]; do
    echo -n "."
    sleep 1
    kubectl -n $NAMESPACE exec "vault-0" -- vault login "$VAULT_ROOT_TOKEN" 2>/dev/null >/dev/null || true
    (kubectl -n $NAMESPACE exec "vault-0" -- vault operator raft list-peers 2>/dev/null|| true) | grep -q vault-0 2>&1> /dev/null
    PEER_READY="$?"

    kubectl -n $NAMESPACE exec "vault-0" -- rm -f ~/.vault-token 2>&1> /dev/null || true
  done
  echo

  REPLICAS_LIST=($REPLICAS)
  for replica in "${REPLICAS_LIST[@]:1}"; do
    message "checking pod vault-${replica} in raft cluster" 1
    PEER_JOINED=1
    while [ $PEER_JOINED != 0 ]; do
      sleep 1
      kubectl -n $NAMESPACE exec "vault-0" -- vault login "$VAULT_ROOT_TOKEN" >/dev/null
      kubectl -n $NAMESPACE exec "vault-0" -- vault operator raft list-peers 2>/dev/null | grep "^vault"
      kubectl -n $NAMESPACE exec "vault-0" -- vault operator raft list-peers 2>/dev/null | grep vault-${replica} >/dev/null
      PEER_JOINED="$?"
      kubectl -n $NAMESPACE exec "vault-0" -- rm -f ~/.vault-token > /dev/null
      if [ $PEER_JOINED != 0 ]; then
        message "joining pod vault-${replica} to raft cluster" 2
        kubectl -n $NAMESPACE exec "vault-${replica}" -- vault operator raft join http://vault-0.vault-internal:8200 >/dev/null || exit 1
        kubectl -n $NAMESPACE exec "vault-${replica}" -- vault operator unseal "$VAULT_UNSEAL_TOKEN" >/dev/null || exit 1
      else
        message "joined pod vault-${replica}" 2
      fi
    done
  done

  for replica in ""${REPLICAS_LIST[@]:1}""; do
    sealed_status=$(kubectl -n $NAMESPACE exec "vault-${replica}" -- vault status -format=json 2>/dev/null | jq -r '.sealed')
    if [ "$sealed_status" == "true" ]; then
      message "unsealing vault-${replica}" 1
      kubectl -n $NAMESPACE exec "vault-${replica}" -- vault operator unseal "$VAULT_UNSEAL_TOKEN" || exit 1
    fi
  done
}

FIRST_RUN=1
export VAULT_ADDR='http://127.0.0.1:8200'
NAMESPACE=vault
initVault

