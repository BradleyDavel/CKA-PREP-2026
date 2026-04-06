# General flow for fixing controlplane:

# 1. Investigate etcd
sudo crictl ps -a | grep etcd
# The etcd container keeps restarting or exiting. Check the logs:
sudo crictl logs <etcd-container-id>
# Or check the kubelet logs for why probes are failing:
sudo journalctl -u kubelet | grep etcd
# The issue is the probes are attempting HTTP on an HTTPS port.
# Fix etcd manifest:
sudo vi /etc/kubernetes/manifests/etcd.yaml
# Change `scheme: HTTP` back to `scheme: HTTPS` for the liveness, readiness, and startup probes.

# 2. Investigate kube-apiserver
# Once etcd is up, check apiserver
sudo crictl ps -a | grep kube-apiserver
sudo crictl logs <kube-apiserver-container-id>
# The logs will indicate an inability to connect to etcd at an incorrect IP/port (e.g. 127.0.0.11:2380).
# Fix apiserver manifest:
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
# Under --etcd-servers, fix the URL to be: https://127.0.0.1:2379
# Save the file and wait for the static pod to recreate.

# 3. Investigate kube-controller-manager
# If the controller manager pod is missing or crashlooping, check kubelet logs:
sudo journalctl -u kubelet | grep kube-controller-manager
# You will see errors about parsing the manifest due to an invalid port ("probe_port" instead of an integer) or failing probes on 192.168.1.99.
# Fix controller manager manifest:
sudo vi /etc/kubernetes/manifests/kube-controller-manager.yaml
# Change `host: 192.168.1.99` back to `host: 127.0.0.1` in the probes.
# Change `port: probe_port` to the correct integer port (e.g., `port: 10252` or `port: 10257`).
# Save the file and wait for the pod to recreate.

# 4. Verify
kubectl get nodes
kubectl get pods -n kube-system
