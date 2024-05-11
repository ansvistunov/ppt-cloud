resource "yandex_iam_service_account" "sa-k8s-external-secrets-operator" {
  name        = "sa-k8s-external-secrets-operator"
  description = "Сервисная учетка для External Secrets Operator с поддержкой Yandex Lockbox"
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "sa-k8s-external-secrets-operator-lockbox-admin" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "lockbox.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s-external-secrets-operator.id}"
}

output "external-secrets-operator-name" {
  value = yandex_iam_service_account.sa-k8s-external-secrets-operator.name
}