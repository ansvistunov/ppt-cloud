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

