#!/bin/bash

set -o errexit
# terraform
cd ./terraform
terraform init
terraform apply -auto-approve

export FOLDER_ID=$(terraform output folder-id | sed -e 's/^"//' -e 's/"$//')
export DOCKER_SERVER_NAME=$(terraform output docker-server-name | sed -e 's/^"//' -e 's/"$//')
export EXTERNAL_SECRETS_SA=$(terraform output external-secrets-operator-name | sed -e 's/^"//' -e 's/"$//')
export CERT_MANAGER_SA=$(terraform output sa-cert-manager-name | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_SECRETS_ID=$(terraform output lockbox_secret_id | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_PASSWD=$(terraform output postgres-password | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_HOST=$(terraform output postgres-host | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_PORT=$(terraform output postgres-port | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_USER=$(terraform output postgres-user | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_DB=$(terraform output postgres-db | sed -e 's/^"//' -e 's/"$//')
export PUBLIC_ZONE=$(terraform output public-zone-name | sed -e 's/^"//' -e 's/"$//')
export PUBLIC_DOMAIN=$(terraform output public-zone-domain | sed -e 's/^"//' -e 's/"$//')
export CERT_EMAIL=$(terraform output cert-email | sed -e 's/^"//' -e 's/"$//')

terraform output kubeconfig > /home/$USER/.kube/config
sed '/EOT/d' -i /home/$USER/.kube/config
echo $POSTGRES_SECRETS_ID
envsubst < ../k8s/external-secret-template.yaml > ../k8s/external-secret.yaml

# Helm
cd ../helm
rm ./external-secrets/ -r -f
rm ./cert-manager-webhook-yandex/ -r -f
echo "removing namespaces...wait 10 seconds to start k8s"
sleep 10
# remove all namespaces first
kubectl delete namespace ns --ignore-not-found=true
sleep 2
kubectl delete namespace external-secrets-operator --ignore-not-found=true
sleep 2
kubectl delete namespace cert-manager --ignore-not-found=true
sleep 2
kubectl delete namespace nginx --ignore-not-found=true
# install External Secrets Operator с поддержкой Yandex Lockbox
yc iam key create  --service-account-name $EXTERNAL_SECRETS_SA --output sa-external-secrets-key.json
sleep 2
export HELM_EXPERIMENTAL_OCI=1 && \
helm pull oci://cr.yandex/yc-marketplace/yandex-cloud/external-secrets/chart/external-secrets \
  --version 0.5.5 \
  --untar && \
helm install --namespace external-secrets-operator --create-namespace --set-file auth.json=sa-external-secrets-key.json  external-secrets ./external-secrets
kubectl create namespace ns
kubectl --namespace ns create secret generic yc-auth  --from-file=authorized-key=sa-external-secrets-key.json


# install Ingress be nginx
kubectl delete namespace nginx --ignore-not-found=true
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create namespace nginx
helm install --namespace nginx ingress-nginx ingress-nginx/ingress-nginx

export BALANCER_IP=$(kubectl -n nginx get services ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
yc dns zone replace-records $PUBLIC_ZONE  --record  "*.nginx.$PUBLIC_DOMAIN 60 A $BALANCER_IP"
yc dns zone list-records $PUBLIC_ZONE

# install cert-manager c плагином Yandex Cloud DNS ACME webhook
kubectl delete namespace cert-manager --ignore-not-found=true
yc iam key create  --service-account-name $CERT_MANAGER_SA --output sa-cert-manager-key.json
export HELM_EXPERIMENTAL_OCI=1 && \
helm pull oci://cr.yandex/yc-marketplace/yandex-cloud/cert-manager-webhook-yandex/cert-manager-webhook-yandex \
  --version 1.0.8-1 \
  --untar && \
helm install \
  --namespace cert-manager \
  --create-namespace \
  --set-file config.auth.json=sa-cert-manager-key.json \
  --set config.email=$CERT_EMAIL \
  --set config.folder_id=$FOLDER_ID \
  --set config.server='https://acme-v02.api.letsencrypt.org/directory' \
  cert-manager-webhook-yandex ./cert-manager-webhook-yandex/

# shell
cd ..
# Install on necessary packets on docker-server
yc compute ssh --name $DOCKER_SERVER_NAME --folder-id $FOLDER_ID < install.script
yc compute ssh --name $DOCKER_SERVER_NAME --folder-id $FOLDER_ID  "export PGPASSWORD=\"$POSTGRES_PASSWD\" && psql --host=$POSTGRES_HOST --port=$POSTGRES_PORT --username=$POSTGRES_USER  --dbname=$POSTGRES_DB -c \"CREATE TABLE IF NOT EXISTS todo_items (id varchar(36) primary key, name varchar(255), section varchar(100),completed boolean);\""

#kubectl
# create secrets for External Secrets Operator
cd ./k8s
kubectl get secrets -n ns
sleep 3
echo "5"
sleep 3
echo "4"
sleep 3
echo "3"
sleep 3
echo "2"
sleep 3
echo "1"
echo "Create secret-story..."
kubectl --namespace ns apply -f secret-story.yaml
sleep 3
echo "external-secret..."
kubectl --namespace ns apply -f external-secret.yaml






