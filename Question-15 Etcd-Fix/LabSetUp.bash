#!/bin/bash
set -e

# Step 1: Backup current manifests
sudo cp /etc/kubernetes/manifests/kube-apiserver.yaml /root/kube-apiserver.yaml.bak
sudo cp /etc/kubernetes/manifests/etcd.yaml /root/etcd.yaml.bak
sudo cp /etc/kubernetes/manifests/kube-controller-manager.yaml /root/kube-controller-manager.yaml.bak

# Step 2: Break etcd probes by targeting the secure 2379 port but keeping scheme as HTTP. 
# It is wrongly set to HTTP and needs to be changed to HTTPS by the user.
sudo sed -i 's/port: 2381/port: 2379/g' /etc/kubernetes/manifests/etcd.yaml

# Step 3: Break kube-apiserver by changing etcd client IP and port
sudo sed -i 's/127.0.0.1:2379/127.0.0.11:2380/g' /etc/kubernetes/manifests/kube-apiserver.yaml

# Step 4: Break kube-controller-manager probes (wrong host, wrong port type)
sudo sed -i 's/127.0.0.1/192.168.1.99/g' /etc/kubernetes/manifests/kube-controller-manager.yaml
sudo sed -i 's/10257/probe_port/g' /etc/kubernetes/manifests/kube-controller-manager.yaml
sudo sed -i 's/10252/probe_port/g' /etc/kubernetes/manifests/kube-controller-manager.yaml

# Step 5: Show kube-apiserver pod status/logs
echo "Checking kube-apiserver container..."
KAPISERVER_ID=$(sudo crictl ps -a | grep kube-apiserver | awk '{print $1}' | head -n 1)
if [ -n "$KAPISERVER_ID" ]; then
    sudo crictl logs "$KAPISERVER_ID" | tail -n 10 || true
else
    echo "kube-apiserver pod not found or not created yet"
fi

# Step 6: Verify that kubectl fails as API server is down
kubectl get nodes || echo "As expected, API server is down due to misconfigured etcd and apiserver manifests."
