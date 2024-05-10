data "yandex_resourcemanager_folder" "folder" {
  folder_id = "b1g8r8qp6rbvo8d589g7"
}

resource "yandex_iam_service_account" "sa-k8-service" {
  name        = "sa-k8-service"
  description = "sa-k8-service"
}

resource "yandex_resourcemanager_folder_iam_member" "k8-cluster-agent" {
  folder_id = "${data.yandex_resourcemanager_folder.folder.folder_id}"
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8-service.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8-publicAdmin" {
  folder_id = "${data.yandex_resourcemanager_folder.folder.folder_id}"
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8-service.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8-loggingWriter" {
  folder_id = "${data.yandex_resourcemanager_folder.folder.folder_id}"
  role      = "logging.writer"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8-service.id}"
}


resource "yandex_iam_service_account" "sa-k8-node-service" {
  name        = "sa-k8-node-service"
  description = "sa-k8-node-service"
}

resource "yandex_resourcemanager_folder_iam_member" "k8-imagePuller" {
  folder_id = "${data.yandex_resourcemanager_folder.folder.folder_id}"
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8-node-service.id}"
}


resource "yandex_kubernetes_cluster" "k8s-cluster" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8-publicAdmin,
    yandex_resourcemanager_folder_iam_member.k8-cluster-agent,
    yandex_resourcemanager_folder_iam_member.k8-loggingWriter,
    yandex_resourcemanager_folder_iam_member.k8-imagePuller
  ]

  name        = "k8s-cluster"
  description = "k8s-cluster for UNN cloud course"

  network_id = "${yandex_vpc_network.course-network.id}"

  master {
    version = "1.26"
    zonal {
      zone      = "ru-central1-a"
      subnet_id = "${yandex_vpc_subnet.course-subnet.id}"
    }

    public_ip = true

    security_group_ids = ["${yandex_vpc_security_group.pgsql-sg.id}"]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }

    master_logging {
      enabled                    = true
      //      log_group_id = "${yandex_logging_group.log_group_resoruce_name.id}"
      kube_apiserver_enabled     = true
      cluster_autoscaler_enabled = true
      events_enabled             = true
      audit_enabled              = true
    }
  }

  service_account_id      = "${yandex_iam_service_account.sa-k8-service.id}"
  node_service_account_id = "${yandex_iam_service_account.sa-k8-node-service.id}"


  release_channel = "REGULAR"
  //network_policy_provider = "CALICO"

  //kms_provider {
  //  key_id = "${yandex_kms_symmetric_key.kms_key_resource_name.id}"
  //}
}


resource "yandex_kubernetes_node_group" "k8s-node-group" {
  cluster_id = yandex_kubernetes_cluster.k8s-cluster.id
  name       = "k8s-node-group"
  instance_template {
    name                      = "k8s-{instance.short_id}"
    platform_id               = "standard-v3"
    network_acceleration_type = "standard"
    container_runtime {
      type = "containerd"
    }

    boot_disk {
      size = 96
      type = "network-hdd"
    }

    resources {
      core_fraction = 100
      cores         = 2
      gpus          = 0
      memory        = 4
    }

    scheduling_policy {
      preemptible = true
    }


  }
  maintenance_policy {
    auto_repair  = false
    auto_upgrade = true
  }

  scale_policy {
    auto_scale {
      min     = 2
      max     = 5
      initial = 3
    }
  }
}

