resource "yandex_container_registry" "course_registry" {
  name = "course-registry"
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id

}