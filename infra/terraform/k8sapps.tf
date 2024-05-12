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


resource "yandex_iam_service_account" "sa-cert-manager" {
  name        = "sa-cert-manager"
  description = "Сервисная учетка для cert-manager c плагином Yandex Cloud DNS ACME webhook"
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "sa-cert-manager-dns-editor" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "dns.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-cert-manager.id}"
}

output "sa-cert-manager-name" {
  value = yandex_iam_service_account.sa-cert-manager.name
}