resource "random_password" "db_password" {
  length           = 10
  special          = false
}

resource "yandex_mdb_postgresql_cluster" "postgresql" {

  depends_on = [
    yandex_vpc_network.k8s-network,
    yandex_vpc_subnet.subnet-a,
    yandex_vpc_security_group.k8s-main-sg
  ]

  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
  name                = "PostgreSQL"
  environment         = "PRODUCTION"
  network_id          = yandex_vpc_network.k8s-network.id
  security_group_ids  = [ yandex_vpc_security_group.k8s-main-sg.id ]
//  deletion_protection = true

  config {
    version = 15
    resources {
      resource_preset_id = "c3-c4-m8"
      disk_type_id       = "network-hdd"
      disk_size          = "10"
    }
    postgresql_config         = {
      "max_connections"          = "800"
      "password_encryption"      = "0"
      "shared_preload_libraries" = null
    }
    access {
      data_lens     = false
      data_transfer = false
      serverless    = true
      web_sql       = true
    }
  }

  host {
    zone      = "ru-central1-a"
    name      = var.postgres_port
    subnet_id = yandex_vpc_subnet.subnet-a.id
  }
}

resource "yandex_mdb_postgresql_database" "db1" {
  depends_on = [
    yandex_mdb_postgresql_user.user1
  ]
  cluster_id = yandex_mdb_postgresql_cluster.postgresql.id
  name       = var.postgres_db
  owner      = var.db_user
}

resource "yandex_mdb_postgresql_user" "user1" {
  cluster_id = yandex_mdb_postgresql_cluster.postgresql.id
  name       = var.db_user
  password   = random_password.db_password.result
  conn_limit = 600
}

