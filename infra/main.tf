terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.89.0"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = var.yc_s3_bucket_name
    region = "ru-central1"
    key    = "tf-state.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  zone                     = var.yc_zone
  service_account_key_file = "service_account_key_file.json"
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
}

# VPS Networks
resource "yandex_vpc_network" "vm_network" {
  name = "vm-network"
}

resource "yandex_vpc_subnet" "vm_subnet" {
  name           = "vm-subnet"
  network_id     = yandex_vpc_network.vm_network.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

# --- Security Group ---
resource "yandex_vpc_security_group" "vm_sec_group" {
  name        = "vm-sec-group"
  network_id  = yandex_vpc_network.vm_network.id
  description = "Allow SSH & HTTP in, allow all out"

  ingress {
    protocol       = "TCP"
    description    = "Allow SSH"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Allow HTTP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "vm" {
  name        = "vm"
  platform_id = "standard-v1"

  resources {
    core_fraction = 5
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8pfd17g205ujpmpb0a"  # Ubuntu 24.04 LTS
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.vm_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.vm_sec_group.id]
  }

  metadata = {
    ssh-keys = "${var.yc_user}:${var.yc_ssh_public_key}"
    user-data = templatefile("${path.module}/cloud-init.yaml",
      {vm_user = var.yc_user}
    )
  }
}
