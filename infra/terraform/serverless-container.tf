resource "yandex_iam_service_account" "sa-serverless-container" {
  name        = "sa-serverless-container"
  description = "Учетка для создания Serverless Containers"
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "sa-serverless-container-lockbox-editor" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "lockbox.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-serverless-container.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-serverless-container-invoker" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "serverless.containers.invoker"
  member    = "serviceAccount:${yandex_iam_service_account.sa-serverless-container.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-serverless-container-image-puller" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa-serverless-container.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-serverless-container-lockbox-viewer" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "lockbox.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.sa-serverless-container.id}"
}