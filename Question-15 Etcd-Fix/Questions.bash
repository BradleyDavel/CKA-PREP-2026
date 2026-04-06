# Question:
# The controlplane components are currently broken and the cluster is inaccessible.
# Several misconfigurations were introduced during a recent maintenance window causing both etcd and kube-apiserver to fail.
#
# Task
# 1. Troubleshoot and fix the etcd container so it starts correctly.
# 2. Fix the kube-apiserver to properly connect to the local etcd instance.
# 3. Fix the kube-controller-manager probes which were intentionally misconfigured to point to an incorrect IP and invalid port.
# Ensure that `kubectl get nodes` works successfully and all core controlplane pods are running.

# Video Link - https://youtu.be/IL448T6r8H4
# Ports exercise - https://puzzel.org/en/matching-pairs/play?p=-OpXPVHM2U8h1klt8Y-q
