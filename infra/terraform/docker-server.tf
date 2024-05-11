resource "yandex_iam_service_account" "sa-vm-cloud" {
  name        = "sa-vm-cloud"
  description = "Учетка, под которой работают виртуальные машины"
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "sa-vm-cloud-editor" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-vm-cloud.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-vm-cloud-compute-viewer" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  role      = "compute.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.sa-vm-cloud.id}"
}


resource "yandex_compute_disk" "boot-disk" {
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  name     = "docker-server-disk"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "30"
  image_id = "fd89ls0nj4oqmlhhi568" //2204-lts-OsLogin
}

resource "yandex_compute_instance" "docker-server" {

  depends_on = [
    yandex_compute_disk.boot-disk,
    yandex_iam_service_account.sa-vm-cloud,
    yandex_resourcemanager_folder_iam_member.sa-vm-cloud-editor
  ]

  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  name                      = "docker-server"
  allow_stopping_for_update = true
  platform_id               = "standard-v3"
  zone                      = "ru-central1-a"
  service_account_id = yandex_iam_service_account.sa-vm-cloud.id
  resources {
    cores  = 4
    memory = 8
    gpus   = 0
    core_fraction = 50
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    enable-oslogin     = true
    serial-port-enable = 0
  }
}

