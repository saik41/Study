## Kubernetes Cheat-Sheet

Commands - 
Cluster info - kubectl cluster-info 
node Info - kubectl get nodes
ADDITIONAL DETAILS of ndoe- kubectl describe node
Deploying any single pod - kubectl run kubia --image=luksa/kubia --port=8080 --generator=run/v1
Listing pods - kubectl get pods
create the service - kubectl expose rc kubia --type=LoadBalancer --name kubia-http (you’ll tell Kubernetes to expose the ReplicationController)
Listing Services - kubectl get svc
Listing Replication Controllers - kubectl get rc
INCREASING THE DESIRED REPLICA COUNT - kubectl scale rc kubia --replicas=3
request additional info - kubectl get pods -o wide
other details pod - kubectl describe pod kubia-hczji
ACCESSING THE DASHBOARD - kubectl cluster-info | grep dashboard
Full YAML of a deployed pod - kubectl get po kubia-zxzij -o yaml
object and lists the attributes of pod - kubectl explain pods
get dipper details - kubectl explain pod.spec
Create the pod - kubectl create -f kubia-manual.yaml
RETRIEVING THE WHOLE DEFINITION OF A RUNNING POD - kubectl get pod kubia-manual -o yaml
To view pods - kubectl get pods
check docker logs - docker logs <container id>
check pod logs - kubectl logs <pod>
check pod logs - kubectl logs kubia-manual -c kubia (GETTING LOGS OF A MULTI-CONTAINER POD)
FORWARDING A LOCAL NETWORK PORT to a pod - kubectl port-forward kubia-manual 8888:8080
check labels - kubectl get po --show-labels
To check certain labels - kubectl get po -L creation_method,env
Modifying labels of existing pods - kubectl label po kubia-manual creation_method=manual
changing existing labels - kubectl label po kubia-manual-v2 env=debug --overwrite
see all pods you created
manually - kubectl get po -l creation_method=manual (Replace with your labels)
list don’t have the env label - kubectl get po -l '!env'
attach label to node - kubectl label node gke-kubia-85f6-node-0rrx gpu=true
list nodes with labels - kubectl get nodes -l gpu=true

Change namespace - kubectl config set-context $(kubectl config current-context) --namespace=<namespace>
Chechk namespace - kubectl config view | grep namespace
Check pods then - kubectl get pods
