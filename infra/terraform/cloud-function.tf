resource "yandex_iam_service_account" "sa-bucket-cloud-function" {
  name        = "sa-bucket-cloud-function"
  description = "Учетка для создания облачных функций, имеющих права чтения/записи в бакет"
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "sa-bucket-cloud-function-lockbox-editor" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "lockbox.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket-cloud-function.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-bucket-cloud-function-lockbox-viewer" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "lockbox.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket-cloud-function.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-bucket-cloud-function-serverless-functions-invoker" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "serverless.functions.invoker"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket-cloud-function.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-bucket-cloud-function.id
  description        = "Статический ключ для доступа к бакетам по S3"
}