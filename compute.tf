# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# blockstorage.tf
#
# Purpose: The following script defines the declaration of computes needed for the PostgreSQL deployment
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance


data "template_cloudinit_config" "cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "ainit.sh"
    content_type = "text/x-shellscript"
    content      = "RSA"
  }
}

resource "oci_core_instance" "postgresql_master" {
  availability_domain = var.availablity_domain_name
  compartment_id      = local.compartment_id
  display_name        = "PostgreSQL_Master"
  shape               = var.postgresql_instance_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_postgresql_instance_shape ? [1] : []
    content {
      memory_in_gbs = var.postgresql_instance_flex_shape_memory
      ocpus         = var.postgresql_instance_flex_shape_ocpus
    }
  }

  dynamic "agent_config" {
    for_each = var.create_in_private_subnet ? [1] : []
    content {
      are_all_plugins_disabled = false
      is_management_disabled   = false
      is_monitoring_disabled   = false
      plugins_config {
        desired_state = "ENABLED"
        name          = "Bastion"
      }
    }
  }

  fault_domain = var.postgresql_master_fd

  create_vnic_details {
    subnet_id        = local.private_subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = var.create_in_private_subnet ? false : true
    hostname_label   = "pgmaster"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID_postgresql_instance_shape.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_is_path ? file(var.ssh_public_key) : var.ssh_public_key
    user_data           = data.template_cloudinit_config.cloud_init.rendered
  }
}

resource "oci_core_instance" "postgresql_hotstandby1" {

  availability_domain = var.postgresql_hotstandby1_ad == "" ? var.availablity_domain_name : var.postgresql_hotstandby1_ad
  compartment_id      = local.compartment_id
  display_name        = "PostgreSQL_HotStandby1"
  shape               = var.postgresql_hotstandby1_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_postgresql_hotstandby1_shape ? [1] : []
    content {
      memory_in_gbs = var.postgresql_hotstandby1_flex_shape_memory
      ocpus         = var.postgresql_hotstandby1_flex_shape_ocpus
    }
  }

  dynamic "agent_config" {
    for_each = var.create_in_private_subnet ? [1] : []
    content {
      are_all_plugins_disabled = false
      is_management_disabled   = false
      is_monitoring_disabled   = false
      plugins_config {
        desired_state = "ENABLED"
        name          = "Bastion"
      }
    }
  }

  fault_domain = var.postgresql_hotstandby1_fd

  create_vnic_details {
    subnet_id        = local.private_subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = var.create_in_private_subnet ? false : true
    hostname_label   = "pgstandby1"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID_postgresql_hotstandby1_shape.images[0].id
  }

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_is_path ? file(var.ssh_public_key) : var.ssh_public_key
  }
}

resource "oci_core_instance" "postgresql_hotstandby2" {

  availability_domain = var.postgresql_hotstandby2_ad == "" ? var.availablity_domain_name : var.postgresql_hotstandby2_ad
  compartment_id      = local.compartment_id
  display_name        = "PostgreSQL_HotStandby2"
  shape               = var.postgresql_hotstandby2_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_postgresql_hotstandby2_shape ? [1] : []
    content {
      memory_in_gbs = var.postgresql_hotstandby2_flex_shape_memory
      ocpus         = var.postgresql_hotstandby2_flex_shape_ocpus
    }
  }

  dynamic "agent_config" {
    for_each = var.create_in_private_subnet ? [1] : []
    content {
      are_all_plugins_disabled = false
      is_management_disabled   = false
      is_monitoring_disabled   = false
      plugins_config {
        desired_state = "ENABLED"
        name          = "Bastion"
      }
    }
  }

  fault_domain = var.postgresql_hotstandby2_fd

  create_vnic_details {
    subnet_id        = local.private_subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = var.create_in_private_subnet ? false : true
    hostname_label   = "pgstandby2"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.InstanceImageOCID_postgresql_hotstandby2_shape.images[0].id
  }

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_is_path ? file(var.ssh_public_key) : var.ssh_public_key
  }
}
