export VIP=192.168.1.252
export INTERFACE=enp3s0
alias kube-vip="docker run --rm --network host --name vip docker.io/plndr/kube-vip:0.3.2"

kube-vip manifest daemonset \
    --arp \
    --interface $INTERFACE \
    --address $VIP \
    --controlplane \
    --leaderElection \
    --inCluster | tee kube-vip-generated.yaml

# Optional
#   * only execute on master nodes
#    --taint \
