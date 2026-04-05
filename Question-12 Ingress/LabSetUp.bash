#!/bin/bash
set -e

echo "Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/baremetal/deploy.yaml

echo "Waiting for NGINX Ingress Controller to be ready..."
sleep 10
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s || true

echo "Patching ingress controller to use hostNetwork (port 80)..."
kubectl -n ingress-nginx patch deployment ingress-nginx-controller \
  --type='json' \
  -p='[
    {"op":"add","path":"/spec/template/spec/hostNetwork","value":true},
    {"op":"add","path":"/spec/template/spec/dnsPolicy","value":"ClusterFirstWithHostNet"}
  ]'

echo "Waiting for patched controller rollout..."
kubectl -n ingress-nginx rollout status deployment ingress-nginx-controller

echo "Getting node IP for /etc/hosts mapping..."
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

echo "Mapping example.org -> $NODE_IP"
grep -q "example.org" /etc/hosts && sed -i '/example.org/d' /etc/hosts
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
