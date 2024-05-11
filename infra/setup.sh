#!/bin/bash

set -o errexit
# terraform
cd ./terraform
terraform init
terraform apply -auto-approve

export FOLDER_ID=$(terraform output folder-id | sed -e 's/^"//' -e 's/"$//')
export DOCKER_SERVER_NAME=$(terraform output docker-server-name | sed -e 's/^"//' -e 's/"$//')
export EXTERNAL_SECRETS_SA=$(terraform output external-secrets-operator-name | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_SECRETS_ID=$(terraform output lockbox_secret_id | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_PASSWD=$(terraform output postgres-password | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_HOST=$(terraform output postgres-host | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_PORT=$(terraform output postgres-port | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_USER=$(terraform output postgres-user | sed -e 's/^"//' -e 's/"$//')
export POSTGRES_DB=$(terraform output postgres-db | sed -e 's/^"//' -e 's/"$//')

terraform output kubeconfig > /home/$USER/.kube/config
sed '/EOT/d' -i /home/$USER/.kube/config
echo $POSTGRES_SECRETS_ID
envsubst < ../k8s/external-secret-template.yaml > ../k8s/external-secret.yaml

# Helm
cd ../helm
rm ./external-secrets/ -r -f
kubectl delete namespace ns --ignore-not-found=true
sleep 2
kubectl delete namespace external-secrets-operator --ignore-not-found=true
yc iam key create  --service-account-name $EXTERNAL_SECRETS_SA --output sa-external-secrets-key.json
export HELM_EXPERIMENTAL_OCI=1 && \
helm pull oci://cr.yandex/yc-marketplace/yandex-cloud/external-secrets/chart/external-secrets \
  --version 0.5.5 \
  --untar && \
helm install --namespace external-secrets-operator --create-namespace --set-file auth.json=sa-external-secrets-key.json  external-secrets ./external-secrets
kubectl create namespace ns
kubectl --namespace ns create secret generic yc-auth  --from-file=authorized-key=sa-external-secrets-key.json




#kubectl
cd ../k8s
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
kubectl --namespace ns apply -f secret-story.yaml
kubectl --namespace ns apply -f external-secret.yaml


# shell
cd ..
# Install on necessary packets on docker-server
yc compute ssh --name $DOCKER_SERVER_NAME --folder-id $FOLDER_ID < install.script
yc compute ssh --name $DOCKER_SERVER_NAME --folder-id $FOLDER_ID  "export PGPASSWORD=$POSTGRES_PASSWD && psql --host=$POSTGRES_HOST --port=$POSTGRES_PORT --username=$POSTGRES_USER  --dbname=$POSTGRES_DB -c \"CREATE TABLE IF NOT EXISTS todo_items (id varchar(36) primary key, name varchar(255), section varchar(100),completed boolean);\""
# install External Secrets Operator с поддержкой Yandex Lockbox
# Step 1: create key



