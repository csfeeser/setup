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
vi awx-demo.yml
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx-demo
spec:
  service_type: nodeport
  ingress_type: none
  hostname: awx-demo.example.com
```

### Run the deployment:

```
kubectl apply -f awx-demo.yml
kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator"
kubectl get svc -l "app.kubernetes.io/managed-by=awx-operator"
```
WAIT A FEW MINS...

### Get the Admin user password:
```
kubectl get secrets
kubectl get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 --decode
```

### Expose the deployment:
```
kubectl expose deployment awx-demo --type=LoadBalancer --port=8080
```

### Minikube tunnel
On a new session, start the minikube tunnel:

```minikube tunnel```

### Enable AWX to be access via the Internet:
```kubectl port-forward svc/awx-demo-service --address 0.0.0.0 30886:80```

Now visit https://your_ip:high_port

**You may need to update your FW rules to be able to connect to the AWX login screen**

---
**---** **ISSUES SECTION** **---**

1) Starting minikube tunnel - Exiting due to GUEST_STATUS: state: unknown state "minikube": docker container inspect minikube --format=: exit status 1
ANS: ```sudo chmod 666 /var/run/docker.sock ; sudo usermod -aG docker ${USER}```

2) If you see the message: ImagePullBackOff or ErrImagePull when you run kubectl get pods, run the following command to see what the issue is:
````
kubectl describe pods <my-pod> # Output from "kubectl get pods" command for the pod with the issue.
````
I've seen a few issues where the server runs out of space so it should be easy to fix.

3) If you have PENDING resources, try running a describe of the resource. If you see this at the bottom you are lacking in resources:
( ```kubectl describe pods <my-pod>``` # Output from ```kubectl get pods``` )
```
Events:
  Type     Reason            Age                 From               Message
  ----     ------            ----                ----               -------
  Warning  FailedScheduling  14s (x19 over 23m)  default-scheduler  0/1 nodes are available: 1 Insufficient cpu, 1 Insufficient memory.
```

This link has some more information:
https://containersolutions.github.io/runbooks/posts/kubernetes/0-nodes-available-insufficient/
