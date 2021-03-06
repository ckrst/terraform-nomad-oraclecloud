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
