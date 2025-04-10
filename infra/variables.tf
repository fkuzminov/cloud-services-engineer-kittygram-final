variable "yc_cloud_id" {
  description   = "Yandex Cloud ID"
  type          = string
}

variable "yc_folder_id" {
  description   = "Yandex Cloud folder ID"
  type          = string
}

variable "yc_user" {
  description = "Yandex Cloud VM user"
  type        = string
  default     = "user"
}

variable "yc_zone" {
  description   = "Zone for Yandex Cloud"
  type          = string
  default       = "ru-central1-a"
}

variable "yc_ssh_public_key" {
    description   = "Public SSH key for Yandex Cloud VM"
    type          = string
}
