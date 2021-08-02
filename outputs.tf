
output "nomad_server" {
  value = oci_core_instance.nomad_server.public_ip
}
