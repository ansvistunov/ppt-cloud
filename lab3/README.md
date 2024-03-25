# Лабораторная работа №3

Установка yc
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

yc init
Идем по предложенной ссылке, получаем токен, вводим его
выбираем облако ansvistunov
и каталог unn-course
Don't set default zone

yc config list

Строим параметры подключения к кластеру
yc managed-kubernetes cluster get-credentials unn-cloud-k8s --internal

kubectl cluster-info
kubectl get pods

kubectl --namespace ns get secret k8s-secret

export STUDENT=<ваша фамилия>
export REGISTRY_ID=<идентификатор реестра - спросите у преподавателя>

envsubst < todo-app-template.yaml > todo-app.yaml
envsubst < load-balancer-template.yaml > load-balancer.yaml

kubectl apply -f todo-app.yaml -n ns
kubectl apply -f load-balancer.yaml -n ns 


kubectl describe deployment lab-k8s-<ваша фамилия> -n ns
kubectl describe service lab-k8s-<ваша фамилия> -n ns

kubectl get deployments

watch curl http://xxx.xxx.xxx.xxx/name

kubectl delete deployment lab-k8s-<ваша фамилия> -n ns
kubectl delete service lab-k8s-<ваша фамилия> -n ns

watch curl http://xxx.xxx.xxx.xxx/name

envsubst < node-template.yaml > node.yaml
envsubst < ingress-template.yaml > ingress.yaml

kubectl apply -f node.yml -n ns
kubectl apply -f ingress.yaml -n ns

kubectl get endpoints -n ns 

https://<ваша фамилия>.nginx.cloud-course.ru

curl https://<ваша фамилия>.nginx.cloud-course.ru/name

kubectl -n ns rollout restart deployment/lab-k8s-<ваша фамилия>

