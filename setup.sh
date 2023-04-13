curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
sudo apt-get update -y &&  sudo apt-get install -y docker.io
curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.21.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
sudo usermod -aG docker $USER

# LOGOUT & BACK IN AGAIN

groups $USER
minikube start --addons=ingress --cpus=2 --install-addons=true --kubernetes-version=stable --memory=6g```
kubectl get nodes
kubectl get pods
kubectl get pods -A
kubectl apply -f https://raw.githubusercontent.com/ansible/awx-operator/0.10.0/deploy/awx-operator.yaml
kubectl get pods
kubectl apply -f awx-demo.yml
kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator"
kubectl get svc -l "app.kubernetes.io/managed-by=awx-operator"

# WAIT A FEW MINS...

### Get the Admin user password:
kubectl get secrets
kubectl get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 --decode

### Expose the deployment:

kubectl expose deployment awx-demo --type=LoadBalancer --port=8080

### Minikube tunnel
# On a new session, start the minikube tunnel:

minikube tunnel

kubectl port-forward svc/awx-demo-service --address 0.0.0.0 30886:80

# Now visit https://your_ip:high_port
