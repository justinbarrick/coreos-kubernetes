#!/bin/bash

if [ -f /opt/bin/crictl ] && [ -f /opt/bin/kubeadm ] && [ -f /opt/bin/kubelet ] && [ -f /opt/bin/kubectl ]; then
  exit
fi

cd /tmp/

curl -L https://github.com/kubernetes-incubator/cri-tools/releases/download/${crictl_version}/crictl-${crictl_version}-linux-amd64.tar.gz |tar xzf -
curl -O https://storage.googleapis.com/kubernetes-release/release/${kubernetes_version}/bin/linux/amd64/kubeadm
curl -O https://storage.googleapis.com/kubernetes-release/release/${kubernetes_version}/bin/linux/amd64/kubelet
curl -O https://storage.googleapis.com/kubernetes-release/release/${kubernetes_version}/bin/linux/amd64/kubectl

install crictl /opt/bin/
install kubeadm /opt/bin/
install kubelet /opt/bin/
install kubectl /opt/bin/
