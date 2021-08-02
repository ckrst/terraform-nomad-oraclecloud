resource "oci_core_instance" "nomad_client1" {
  count = 0
  availability_domain = "nbBK:US-ASHBURN-AD-1"
  compartment_id = var.oracle_compartment_id
  shape = "VM.Standard.E2.1.Micro"
  display_name = "Nomad Client 1"

  create_vnic_details {
    assign_public_ip = true
    nsg_ids = [ oci_core_network_security_group.nomad_network_security_group.id ]
    subnet_id = oci_core_subnet.nomad_subnet.id
  }
  metadata = {
    ssh_authorized_keys = var.public_key
  }
  source_details {
    source_id = data.oci_core_image.ubuntu_image.image_id
    source_type = "image"
  }
}
