resource "yandex_dns_zone" "public_zone" {
  name        = "public-zone"
  description = "Public DNS zone for Ingress"
  zone             = "${var.nginx_domain}."
  public           = true
  folder_id = data.yandex_resourcemanager_folder.folder.folder_id
}

/*
resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.public_zone.id
  name    = "srv.example.com."
  type    = "A"
  ttl     = 200
  data    = ["10.1.0.1"]
}*/


output "public-zone-name" {
  value = yandex_dns_zone.public_zone.name
}

output "public-zone-domain" {
  value = yandex_dns_zone.public_zone.zone
}