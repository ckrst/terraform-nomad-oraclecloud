terraform {
  backend "remote" {}
}

provider "oci" {
  tenancy_ocid = var.oracle_tenancy_ocid
  user_ocid = var.oracle_user_ocid
  fingerprint = var.oracle_fingerprint
  private_key = var.oracle_private_key
  region = var.oracle_region
}

data "oci_core_image" "ubuntu_image" {
  #Required
  image_id = "ocid1.image.oc1.iad.aaaaaaaalnsxbpterctwu7k3kfadhizokykbs7pbdehxypj7ogpsmv4rjita"
}

# NOMAD NETWORK

resource "oci_core_vcn" "nomad_vcn" {
    compartment_id = var.oracle_compartment_id

    cidr_block = "10.0.0.0/16"
    display_name = "NomadVCN"
    dns_label = "nomadvcn"

    # cidr_blocks = [
    #   "10.0.0.0/16",
    # ]
    defined_tags = {
      "Oracle-Tags.CreatedBy" = "oracleidentitycloudservice/${var.oracle_account_email}"
      # "Oracle-Tags.CreatedOn" = "2021-04-09T05:17:53.824Z"
    }
    freeform_tags = {}
    is_ipv6enabled = false
    timeouts {}
}

resource "oci_core_subnet" "nomad_subnet" {
    #Required
    cidr_block = "10.0.0.0/24"
    compartment_id = var.oracle_compartment_id
    vcn_id = oci_core_vcn.nomad_vcn.id

    #Optional
    display_name = "NomadSubnet"
    dns_label = "nomadsubnet"

    defined_tags = {
      "Oracle-Tags.CreatedBy" = "oracleidentitycloudservice/vinicius.kirst@gmail.com"
      # "Oracle-Tags.CreatedOn" = "2021-04-09T05:17:56.745Z"
    }
    dhcp_options_id = oci_core_dhcp_options.nomad_dhcp_options.id
    freeform_tags = {}
    prohibit_internet_ingress = false
    prohibit_public_ip_on_vnic = false
    route_table_id = oci_core_route_table.nomad_route_table.id
    security_list_ids = [
      oci_core_security_list.nomad_security_list.id,
    ]
}
