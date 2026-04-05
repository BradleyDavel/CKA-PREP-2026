#!/bin/bash
set -e

echo "Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/baremetal/deploy.yaml

echo "Waiting for NGINX Ingress Controller to be created..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s || true

echo "Patching ingress controller to listen on host network..."
kubectl -n ingress-nginx patch deployment ingress-nginx-controller \
  --type='merge' \
  -p '{"spec":{"template":{"spec":{"hostNetwork":true,"dnsPolicy":"ClusterFirstWithHostNet"}}}}'

echo "Restarting ingress controller..."
kubectl -n ingress-nginx rollout restart deployment ingress-nginx-controller
kubectl -n ingress-nginx rollout status deployment ingress-nginx-controller --timeout=180s

echo "Finding node IP where ingress controller is running..."
CONTROLLER_NODE=$(kubectl -n ingress-nginx get pod -l app.kubernetes.io/component=controller -o jsonpath='{.items[0].spec.nodeName}')
NODE_IP=$(kubectl get node "$CONTROLLER_NODE" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')

echo "Updating /etc/hosts so example.org points to $NODE_IP ..."
sed -i '/[[:space:]]example\.org$/d' /etc/hosts
echo "$NODE_IP example.org" >> /etc/hosts

echo "Creating namespace: echo-sound"
kubectl create ns echo-sound || true

echo "Deploying Echo Server in namespace: echo-sound"
cat <<EOF | kubectl -n echo-sound apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo
  namespace: echo-sound
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      containers:
      - name: echo
        image: gcr.io/google_containers/echoserver:1.10
        ports:
        - containerPort: 8080
EOF

echo "✅ Echo server and NGINX Ingress Controller deployed successfully!"
