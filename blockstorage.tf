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
  availability_domain = var.postgresql_master_ad
  compartment_id      = local.compartment_id
  display_name        = "${oci_core_instance.postgresql_master.display_name}_disk"
  size_in_gbs         = var.database_size_in_gb
  vpus_per_gb         = var.database_vpus_per_gb
}

# Create Disk Attachment
resource "oci_core_volume_attachment" "ISCSIDiskAttachment_master" {
  depends_on      = [oci_core_volume.ISCSIDisk_master]
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.postgresql_master.id
  volume_id       = oci_core_volume.ISCSIDisk_master.id
}

# Assignment of backup policy for ProdDisk
resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_ISCSI_Disk_master" {
  asset_id  = oci_core_volume.ISCSIDisk_master.id
  policy_id = local.database_backup_policy_id
}

resource "oci_core_volume" "ISCSIDisk_hotstandby1" {
  count               = var.postgresql_deploy_hotstandby1 ? 1 : 0
  availability_domain = var.postgresql_hotstandby1_ad
  compartment_id      = local.compartment_id
  display_name        = "${oci_core_instance.postgresql_hotstandby1[count.index].display_name}_disk"
  size_in_gbs         = var.database_size_in_gb
  vpus_per_gb         = var.database_vpus_per_gb
}

# Create Disk Attachment
resource "oci_core_volume_attachment" "ISCSIDiskAttachment_hotstandby1" {
  count           = var.postgresql_deploy_hotstandby1 ? 1 : 0
  depends_on      = [oci_core_volume.ISCSIDisk_hotstandby1]
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.postgresql_hotstandby1[count.index].id
  volume_id       = oci_core_volume.ISCSIDisk_hotstandby1[count.index].id
}

# Assignment of backup policy for ProdDisk
resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_ISCSI_Disk_hotstandby1" {
  count     = var.postgresql_deploy_hotstandby1 ? 1 : 0
  asset_id  = oci_core_volume.ISCSIDisk_hotstandby1[count.index].id
  policy_id = local.database_backup_policy_id
}


resource "oci_core_volume" "ISCSIDisk_hotstandby2" {
  count               = var.postgresql_deploy_hotstandby2 ? 1 : 0
  availability_domain = var.postgresql_hotstandby2_ad
  compartment_id      = local.compartment_id
  display_name        = "${oci_core_instance.postgresql_hotstandby2[count.index].display_name}_disk"
  size_in_gbs         = var.database_size_in_gb
  vpus_per_gb         = var.database_vpus_per_gb
}

# Create Disk Attachment
resource "oci_core_volume_attachment" "ISCSIDiskAttachment_hotstandby2" {
  count           = var.postgresql_deploy_hotstandby2 ? 1 : 0
  depends_on      = [oci_core_volume.ISCSIDisk_hotstandby2]
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.postgresql_hotstandby2[count.index].id
  volume_id       = oci_core_volume.ISCSIDisk_hotstandby2[count.index].id
}

# Assignment of backup policy for ProdDisk
resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment_ISCSI_Disk_hotstandby2" {
  count     = var.postgresql_deploy_hotstandby2 ? 1 : 0
  asset_id  = oci_core_volume.ISCSIDisk_hotstandby2[count.index].id
  policy_id = local.database_backup_policy_id
}