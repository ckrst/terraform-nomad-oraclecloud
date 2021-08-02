data "oci_core_image" "ubuntu_image" {
  #Required
  # image_id = "ocid1.image.oc1.iad.aaaaaaaalnsxbpterctwu7k3kfadhizokykbs7pbdehxypj7ogpsmv4rjita" #minimal
  image_id = "ocid1.image.oc1.iad.aaaaaaaayfc7vgsvgtmrlka74mdhyawbjmpcllntrowcuimb6nfxyqur734q"
  }

data "oci_core_image" "arm_ubuntu_image" {
  #Required
  # image_id = "ocid1.image.oc1.iad.aaaaaaaalnsxbpterctwu7k3kfadhizokykbs7pbdehxypj7ogpsmv4rjita" #minimal
  image_id = "ocid1.image.oc1.iad.aaaaaaaaoomqgvfu6zd3dhtrilbvo2s7qhmlqiodcogoonhpc2kgl5qlhddq"
}

# oracle instances
resource "oci_core_instance" "nomad_server" {
  availability_domain = var.oracle_availability_domain
  compartment_id = var.oracle_compartment_id
  shape = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    assign_public_ip = true
    nsg_ids = [ oci_core_network_security_group.nomad_network_security_group.id ]
    subnet_id = oci_core_subnet.nomad_subnet.id
  }
  display_name = "Nomad Server"
  metadata = {
    ssh_authorized_keys = var.public_key
    ssh_authorized_keys = var.public_key
    # userdata = ""
  }arm_
  source_details {
      source_id = data.oci_core_image.ubuntu_image.image_id
      source_type = "image"
  }
}

# resource "null_resource" "nomad_server_provision" {
#   count = 0
#   connection {
#       host = "${oci_core_instance.nomad_server[0].public_ip}"
#       type = "ssh"
#       user = "ubuntu"
#       private_key = "${file("./ssh/id_rsa")}"
#   }
#
#   provisioner "file" {
#     source      = "ssh/id_rsa"
#     destination = "/home/ubuntu/.ssh/cluster_key"
#   }
#   provisioner "file" {
#     source      = "nomad/nomad.service"
#     destination = "/home/ubuntu/nomad.service"
#   }
#   provisioner "file" {
#     source      = "nomad/nomad.hcl"
#     destination = "/home/ubuntu/nomad.hcl"
#   }
#   provisioner "file" {
#     source      = "nomad/server.hcl"
#     destination = "/home/ubuntu/server.hcl"
#   }
#   provisioner "file" {
#     source      = "nomad/client.hcl"
#     destination = "/home/ubuntu/client.hcl"
#   }
#
#   # ssh key
#   provisioner "remote-exec" {
#     inline = [
#       # "chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa",
#       "chmod 400 /home/ubuntu/.ssh/id_rsa"
#     ]
#   }
#
#   # initial packages
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update",
#       "sudo apt install -y software-properties-common iputils-ping vim unzip bash-completion"
#     ]
#   }
#
#   # nomad
#   provisioner "remote-exec" {
#
#     inline = [
#       # install nomad
#       "curl --silent --remote-name https://releases.hashicorp.com/nomad/${var.nomad_version}/nomad_${var.nomad_version}_linux_amd64.zip",
#       "unzip nomad_${var.nomad_version}_linux_amd64.zip",
#       "sudo chown root:root nomad",
#       "sudo mv nomad /usr/local/bin/",
#       "nomad version",
#       # "nomad -autocomplete-install",
#       # "complete -C /usr/local/bin/nomad nomad",
#       "sudo mkdir --parents /opt/nomad",
#
#       # create nomad service
#       "sudo chown root:root nomad.service",
#       "sudo mv nomad.service /etc/systemd/system/nomad.service",
#
#       # configure nomad
#       "sudo mkdir --parents /etc/nomad.d",
#       "sudo chmod 700 /etc/nomad.d",
#       "sudo chown root:root nomad.hcl",
#       "sudo mv /home/ubuntu/nomad.hcl /etc/nomad.d/",
#       "sudo chown root:root server.hcl",
#       "sudo mv /home/ubuntu/server.hcl /etc/nomad.d/",
#       "sudo chown root:root client.hcl",
#       "sudo mv /home/ubuntu/client.hcl /etc/nomad.d/",
#
#       # start
#       "sudo systemctl enable nomad",
#       "sudo systemctl start nomad",
#       "sudo systemctl status nomad"
#     ]
#   }
#
#
#   # Install nomad via packages
#   # provisioner "remote-exec" {
#   #   inline = [
#   #     "$ curl --silent --remote-name https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip",
#   #
#   #
#   #     # PACKAGES
#   #     # "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
#   #     # "sudo apt-add-repository \"deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main\"",
#   #     # "sudo apt-get update && sudo apt-get install -y nomad",
#   #     # "sudo systemctl enable nomad",
#   #     # "sudo systemctl start nomad"
#   #   ]
#   #   # on_failure = continue
#   # }
# }
