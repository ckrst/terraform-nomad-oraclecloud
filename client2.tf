

resource "oci_core_instance" "nomad_arm_client" {
  count = 0
  availability_domain = "nbBK:US-ASHBURN-AD-1"
  compartment_id = var.oracle_compartment_id
  shape = "VM.Standard.A1.Flex"
  defined_tags = {
    "Oracle-Tags.CreatedBy" = "oracleidentitycloudservice/vinicius.kirst@gmail.com"
    # "Oracle-Tags.CreatedOn" = "2021-06-24T13:30:34.821Z"
  }
  display_name = "Nomad Client ARM 1"
  extended_metadata = {}
  freeform_tags = {}
  metadata = {
    ssh_authorized_keys = var.public_key
  }

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled = false
    is_monitoring_disabled = false

    plugins_config {
      desired_state = "ENABLED"
      name = "Compute Instance Monitoring"
    }
  }

  availability_config {
    is_live_migration_preferred = false
    recovery_action = "RESTORE_INSTANCE"
  }

  create_vnic_details {
    # assign_private_dns_record = false
    assign_public_ip = false
    defined_tags = {
      "Oracle-Tags.CreatedBy" = "oracleidentitycloudservice/vinicius.kirst@gmail.com"
      # "Oracle-Tags.CreatedOn" = "2021-06-24T13:30:35.220Z"
    }
    display_name = "Nomad Client ARM 1"
    freeform_tags = {}
    hostname_label = "nomad-client-arm-1"
    nsg_ids = []
    skip_source_dest_check = false
    subnet_id = oci_core_subnet.nomad_subnet.id
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = false
  }

  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    firmware = "UEFI_64"
    is_consistent_volume_naming_enabled = true
    is_pv_encryption_in_transit_enabled = true
    network_type = "PARAVIRTUALIZED"
    remote_data_volume_type = "PARAVIRTUALIZED"
  }

  shape_config {
    memory_in_gbs = 24
    ocpus = 4
  }

  source_details {
    # boot_volume_size_in_gbs = "47"
    source_id = "ocid1.image.oc1.iad.aaaaaaaaoomqgvfu6zd3dhtrilbvo2s7qhmlqiodcogoonhpc2kgl5qlhddq"
    source_type = "image"
  }
}
