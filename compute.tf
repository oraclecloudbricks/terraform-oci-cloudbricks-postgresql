# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# compute.tf
#
# Purpose: The following script defines the declaration of computes needed for the PostgreSQL deployment
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance


resource "oci_core_instance" "postgresql_master" {
  availability_domain = var.postgresql_master_ad
  compartment_id      = local.compartment_id
  display_name        = var.postgresql_master_name
  shape               = var.postgresql_master_shape

  dynamic "shape_config" {
    for_each = var.postgresql_master_is_flex_shape ? [1] : []
    content {
      ocpus         = var.postgresql_master_ocpus
      memory_in_gbs = var.postgresql_master_memory_in_gb
    }
  }

  fault_domain = var.postgresql_master_fd

  create_vnic_details {
    subnet_id        = local.private_subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = false
    hostname_label   = var.postgresql_master_name
    nsg_ids          = local.nsg_id == "" ? [] : [local.nsg_id]
  }

  source_details {
    source_type = "image"
    source_id   = local.base_compute_image_ocid
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}

resource "oci_core_instance" "postgresql_hotstandby1" {
  count               = var.postgresql_deploy_hotstandby1 ? 1 : 0
  availability_domain = var.postgresql_hotstandby1_ad == "" ? var.postgresql_master_ad : var.postgresql_hotstandby1_ad
  compartment_id      = local.compartment_id
  display_name        = var.postgresql_standyby1_name
  shape               = var.postgresql_hotstandby_shape

  dynamic "shape_config" {
    for_each = var.postgresql_hotstandby_is_flex_shape ? [1] : []
    content {
      ocpus         = var.postgresql_hotstandby_ocpus
      memory_in_gbs = var.postgresql_hotstandby_memory_in_gb
    }
  }

  fault_domain = var.postgresql_hotstandby1_fd

  create_vnic_details {
    subnet_id        = local.private_subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = false
    hostname_label   = var.postgresql_standyby1_name
    nsg_ids          = local.nsg_id == "" ? [] : [local.nsg_id]
  }

  source_details {
    source_type = "image"
    source_id   = local.base_compute_image_ocid
  }

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}

resource "oci_core_instance" "postgresql_hotstandby2" {
  count               = var.postgresql_deploy_hotstandby2 ? 1 : 0
  availability_domain = var.postgresql_hotstandby2_ad == "" ? var.postgresql_master_ad : var.postgresql_hotstandby2_ad
  compartment_id      = local.compartment_id
  display_name        = var.postgresql_standyby2_name
  shape               = var.postgresql_hotstandby_shape

  dynamic "shape_config" {
    for_each = var.postgresql_hotstandby_is_flex_shape ? [1] : []
    content {
      ocpus         = var.postgresql_hotstandby_ocpus
      memory_in_gbs = var.postgresql_hotstandby_memory_in_gb
    }
  }

  fault_domain = var.postgresql_hotstandby2_fd

  create_vnic_details {
    subnet_id        = local.private_subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = false
    hostname_label   = var.postgresql_standyby2_name
    nsg_ids          = local.nsg_id == "" ? [] : [local.nsg_id]
  }

  source_details {
    source_type = "image"
    source_id   = local.base_compute_image_ocid
  }

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "opc"
    private_key = var.ssh_private_is_path ? file(var.ssh_private_key) : var.ssh_private_key
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}

resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_postgresql_master" {
  depends_on = [oci_core_instance.postgresql_master]
  asset_id   = oci_core_instance.postgresql_master.boot_volume_id
  policy_id  = local.instance_backup_policy_id
}

resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_postgresql_hotstandby1" {
  count      = var.postgresql_deploy_hotstandby1 ? 1 : 0
  depends_on = [oci_core_instance.postgresql_hotstandby1]
  asset_id   = oci_core_instance.postgresql_hotstandby1[0].boot_volume_id
  policy_id  = local.instance_backup_policy_id
}

resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_postgresql_hotstandby2" {
  count      = var.postgresql_deploy_hotstandby2 ? 1 : 0
  depends_on = [oci_core_instance.postgresql_hotstandby2]
  asset_id   = oci_core_instance.postgresql_hotstandby2[0].boot_volume_id
  policy_id  = local.instance_backup_policy_id
}
