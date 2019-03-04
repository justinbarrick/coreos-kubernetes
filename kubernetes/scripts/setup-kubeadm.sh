#!/bin/bash
if [ -f /etc/kubernetes/kubelet.conf ]; then
  exit
fi

export PATH=/opt/bin/:$PATH

while [ 1 ]; do
  if [[ "$(hostname)" == master-0 ]]; then
    kubeadm init --config /etc/kubeadm.conf
  else
    rm -rf /etc/kubernetes/manifests/
    kubeadm join --config /etc/kubeadm.conf
  fi

  if [ "$?" == 0 ]; then
    exit
  fi

  sleep 3
done
