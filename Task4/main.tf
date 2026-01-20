terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = var.default_zone
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "portal" {
  name = "portal-disk"
  type = "network-ssd"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 10
}
resource "yandex_compute_disk" "catalogue" {
  name = "catalog-disk"
  type = "network-ssd"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 10
}
resource "yandex_compute_disk" "nifi" {
  name = "nifi-disk"
  type = "network-ssd"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 10
}
resource "yandex_compute_disk" "finance" {
  name = "finance-disk"
  type = "network-ssd"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 10
}

resource "yandex_vpc_address" "portal_ext_addr" {
  external_ipv4_address {
    zone_id = var.default_zone
  }
}

resource "yandex_vpc_network" "internal_network" {
  name = var.network_name
}


resource "yandex_vpc_subnet" "internal-subnet-a" {
  v4_cidr_blocks = var.int_ntwrk_cidr
  zone           = var.default_zone
  network_id     = yandex_vpc_network.internal_network.id
}

resource "yandex_compute_instance" "portal" {
  name = "portal-vm"
  zone = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.portal.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.internal-subnet-a.id
    nat       = true
    nat_ip_address = yandex_vpc_address.portal_ext_addr.external_ipv4_address[0].address
    security_group_ids = [ yandex_vpc_security_group.web_service.id ] 
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "data_catalogue_manager" {
  name = "data-catalogue-manager-vm"
  zone = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.catalogue.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.internal-subnet-a.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "nifi" {
  name = "nifi-vm"
  zone = var.default_zone

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.nifi.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.internal-subnet-a.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "finance_api" {
  name = "finance-api-vm"
  zone = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.finance.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.internal-subnet-a.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

