# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# blockstorage.tf
#
# Purpose: The following script defines the declaration for block volumes using ISCSI Disks
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_attachment
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_volume_backup_policy_assignment


# Create Disk
resource "oci_core_volume" "ISCSIDisk_master" {
  availability_domain = var.availablity_domain_name
  compartment_id      = local.compartment_id
  display_name        = "${oci_core_instance.postgresql_master.display_name}_disk"
  size_in_gbs         = var.disk_size_in_gb
  vpus_per_gb         = var.vpus_per_gb

}

# Create Disk Attachment
resource "oci_core_volume_attachment" "ISCSIDiskAttachment_master" {
  depends_on      = [oci_core_volume.ISCSIDisk_master]
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.postgresql_master.id
  volume_id       = oci_core_volume.ISCSIDisk_master.id
}

# Assignament of backup policy for ProdDisk
resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_ISCSI_Disk_master" {
  asset_id  = oci_core_volume.ISCSIDisk_master.id
  policy_id = local.backup_policy_iscsi_disk_id
}

resource "oci_core_volume" "ISCSIDisk_hotstandby1" {
  availability_domain = var.availablity_domain_name
  compartment_id      = local.compartment_id
  display_name        = "${oci_core_instance.postgresql_hotstandby1.display_name}_disk"
  size_in_gbs         = var.disk_size_in_gb
  vpus_per_gb         = var.vpus_per_gb

}

# Create Disk Attachment
resource "oci_core_volume_attachment" "ISCSIDiskAttachment_hotstandby1" {
  depends_on      = [oci_core_volume.ISCSIDisk_hotstandby1]
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.postgresql_hotstandby1.id
  volume_id       = oci_core_volume.ISCSIDisk_hotstandby1.id
}

# Assignament of backup policy for ProdDisk
resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_ISCSI_Disk_hotstandby1" {
  asset_id  = oci_core_volume.ISCSIDisk_hotstandby1.id
  policy_id = local.backup_policy_iscsi_disk_id
}


resource "oci_core_volume" "ISCSIDisk_hotstandby2" {
  availability_domain = var.availablity_domain_name
  compartment_id      = local.compartment_id
  display_name        = "${oci_core_instance.postgresql_hotstandby2.display_name}_disk"
  size_in_gbs         = var.disk_size_in_gb
  vpus_per_gb         = var.vpus_per_gb

}

# Create Disk Attachment
resource "oci_core_volume_attachment" "ISCSIDiskAttachment_hotstandby2" {
  depends_on      = [oci_core_volume.ISCSIDisk_hotstandby2]
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.postgresql_hotstandby2.id
  volume_id       = oci_core_volume.ISCSIDisk_hotstandby2.id
}

# Assignament of backup policy for ProdDisk
resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_ISCSI_Disk_hotstandby2" {
  asset_id  = oci_core_volume.ISCSIDisk_hotstandby2.id
  policy_id = local.backup_policy_iscsi_disk_id
}