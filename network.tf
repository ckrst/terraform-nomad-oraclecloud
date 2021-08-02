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
      "Oracle-Tags.CreatedBy" = "oracleidentitycloudservice/${var.oracle_account_email}"
      # "Oracle-Tags.CreatedOn" = "2021-04-09T05:17:56.745Z"
    }
    dhcp_options_id = oci_core_dhcp_options.nomad_dhcp_options.id
    freeform_tags = {}
    prohibit_internet_ingress = false
    prohibit_public_ip_on_vnic = false
    # route_table_id = oci_core_route_table.nomad_route_table.id
    route_table_id = oci_core_vcn.nomad_vcn.default_route_table_id
    security_list_ids = [
      oci_core_security_list.nomad_security_list.id,
    ]
}

resource "oci_core_internet_gateway" "nomad_internet_gateway" {
    compartment_id = var.oracle_compartment_id
    vcn_id = oci_core_vcn.nomad_vcn.id
    display_name = "NomadInternetGateway"
}

# resource "oci_core_route_table" "nomad_route_table" {
#   compartment_id = var.oracle_compartment_id
#   vcn_id = oci_core_vcn.nomad_vcn.id
#
#   display_name = "Nomad Route Table"
#
#   route_rules {
#     destination       = "0.0.0.0/0"
#     destination_type  = "CIDR_BLOCK"
#     network_entity_id = oci_core_internet_gateway.nomad_internet_gateway.id
#   }
# }

locals {
  search_domain_name = "${oci_core_vcn.nomad_vcn.dns_label}.oraclevcn.com"
}

resource "oci_core_dhcp_options" "nomad_dhcp_options" {
  compartment_id = var.oracle_compartment_id
  vcn_id = oci_core_vcn.nomad_vcn.id

  display_name = "Nomad DHCP Options"

  options {
    custom_dns_servers  = []
    search_domain_names = []
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    custom_dns_servers  = []
    search_domain_names = [
      local.search_domain_name,
    ]
    type = "SearchDomain"
  }
}

resource "oci_core_security_list" "nomad_security_list" {
  compartment_id = var.oracle_compartment_id
  vcn_id = oci_core_vcn.nomad_vcn.id
  display_name = "Nomad Security List"

  egress_security_rules {
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol = "all"
    stateless = false
  }
  # ingress_security_rules {
  #   protocol = "1" ICMP
  #   source = "10.0.0.0/16"
  #   source_type = "CIDR_BLOCK"
  #   stateless = false
  #   icmp_options {
  #     code = -1
  #     type = 3
  #   }
  # }
  # ingress_security_rules {
  #   protocol = "1" # ICMP
  #   source = "0.0.0.0/0"
  #   source_type = "CIDR_BLOCK"
  #   stateless = false
  #   icmp_options {
  #     code = 4
  #     type = 3
  #   }
  # }
  ingress_security_rules {
    protocol = "1" # ICMP
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless = false
    # icmp_options {
    #   # code = 4
    #   # type = 3
    # }
  }
  ingress_security_rules {
    protocol = "6" # TCP
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless = false
    tcp_options {
      max = 22
      min = 22
    }
  }
}

resource "oci_core_network_security_group" "nomad_network_security_group" {
    compartment_id = var.oracle_compartment_id
    vcn_id = oci_core_vcn.nomad_vcn.id
    display_name = "Nomad Security Group"
}

resource "oci_core_network_security_group_security_rule" "nomad_network_security_group_security_rule_web" {
    network_security_group_id = oci_core_network_security_group.nomad_network_security_group.id
    direction = "INGRESS"
    protocol = "6" #TCP
    description = "Allow web port"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    # stateless = false
    tcp_options {
      destination_port_range {
        min = "80"
        max = "80"
      }
    }
}
resource "oci_core_network_security_group_security_rule" "nomad_network_security_group_security_rule_ingress" {
    network_security_group_id = oci_core_network_security_group.nomad_network_security_group.id
    direction = "INGRESS"
    protocol = "6" #TCP
    description = "Allow nomad ports"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    # stateless = false
    tcp_options {
      destination_port_range {
        min = "4646"
        max = "4648"
      }
    }
}

resource "oci_core_network_security_group_security_rule" "nomad_network_security_group_security_rule_egress" {
  network_security_group_id = oci_core_network_security_group.nomad_network_security_group.id
  direction = "EGRESS"
  protocol = "all"
  description = "Allow all tcp ports"
  destination = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"

}
