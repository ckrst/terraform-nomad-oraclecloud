terraform {
  backend "remote" {}
}

provider "oci" {
  tenancy_ocid     = var.oracle_tenancy_ocid
  user_ocid        = var.oracle_user_ocid
  fingerprint      = var.oracle_fingerprint
  private_key_path = var.oracle_private_key_path
  region           = var.oracle_region
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

    cidr_blocks = [
      "10.0.0.0/16",
    ]
    defined_tags = {
      "Oracle-Tags.CreatedBy" = "oracleidentitycloudservice/${var.oracle_account_email}"
      # "Oracle-Tags.CreatedOn" = "2021-04-09T05:17:53.824Z"
    }
    freeform_tags = {}
    is_ipv6enabled = false
    timeouts {}
}
