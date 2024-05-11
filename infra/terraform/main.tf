variable "yc_token" {
  type = string
  description = "Yandex Cloud API key"
}

variable "yc_cloud_id" {
  type = string
  description = "Yandex Cloud id"
}

variable "yc_folder_id" {
  type = string
  description = "Yandex Cloud folder id"
}

variable "db_user" {
  type = string
  description = "user, created in db"
}

variable "db_password" {
  type = string
  description = "password for db user"
}

variable "postgres_port" {
  type = string
  description = "port to connect to db"
}

variable "postgres_host" {
  type = string
  description = "host to connect to db"
}

variable "postgres_db" {
  type = string
  description = "database name"
}





terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
}

data "yandex_resourcemanager_folder" "folder" {
  folder_id = var.yc_folder_id
}

output "folder-id" {
  value = data.yandex_resourcemanager_folder.folder.folder_id
}

output "docker-server-name" {
  value = yandex_compute_instance.docker-server.name
}


