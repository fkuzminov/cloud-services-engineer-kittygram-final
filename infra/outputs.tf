output "vm_public_ip" {
  description = "VM public IP address"
  value       = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}
