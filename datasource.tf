# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# datasource.tf
#
# Purpose: The following script defines the lookup logic used in code to obtain pre-created or JIT-created resources in tenancy.


data "oci_core_vnic_attachments" "postgresql_master_vnics" {
  compartment_id      = local.compartment_id
  availability_domain = var.availablity_domain_name
  instance_id         = oci_core_instance.postgresql_master.id
}


data "oci_core_vnic_attachments" "postgresql_master_primaryvnic_attach" {
  availability_domain = var.availablity_domain_name
  compartment_id      = local.compartment_id
  instance_id         = oci_core_instance.postgresql_master.id
}

data "oci_core_vnic" "postgresql_master_primaryvnic" {
  vnic_id = data.oci_core_vnic_attachments.postgresql_master_primaryvnic_attach.vnic_attachments.0.vnic_id
}

data "oci_core_vnic_attachments" "postgresql_hotstandby1_primaryvnic_attach" {
  count               = var.postgresql_deploy_hotstandby1 ? 1 : 0
  availability_domain = var.postgresql_hotstandby1_ad
  compartment_id      = local.compartment_id
  instance_id         = oci_core_instance.postgresql_hotstandby1.id
}

data "oci_core_vnic" "postgresql_hotstandby1_primaryvnic" {
  count   = var.postgresql_deploy_hotstandby1 ? 1 : 0
  vnic_id = data.oci_core_vnic_attachments.postgresql_hotstandby1_primaryvnic_attach[count.index].vnic_attachments.0.vnic_id
}

data "oci_core_vnic_attachments" "postgresql_hotstandby2_primaryvnic_attach" {
  count               = var.postgresql_deploy_hotstandby2 ? 1 : 0
  availability_domain = var.postgresql_hotstandby2_ad
  compartment_id      = local.compartment_id
  instance_id         = oci_core_instance.postgresql_hotstandby2.id
}

data "oci_core_vnic" "postgresql_hotstandby2_primaryvnic" {
  count   = var.postgresql_deploy_hotstandby2 ? 1 : 0
  vnic_id = data.oci_core_vnic_attachments.postgresql_hotstandby2_primaryvnic_attach[count.index].vnic_attachments.0.vnic_id
}


# Get the latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID_postgresql_instance_shape" {
  compartment_id           = local.compartment_id
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.postgresql_instance_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

# Get the latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID_postgresql_hotstandby1_shape" {
  compartment_id           = local.compartment_id
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.postgresql_hotstandby1_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

# Get the latest Oracle Linux image
data "oci_core_images" "InstanceImageOCID_postgresql_hotstandby2_shape" {
  compartment_id           = local.compartment_id
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.postgresql_hotstandby2_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

data "oci_identity_region_subscriptions" "home_region_subscriptions" {
  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}




# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# datasource.tf
#
# Purpose: The following script defines the lookup logic used in code to obtain pre-created or JIT-created resources in tenancy.


/********** Compartment and CF Accessors **********/
data "oci_identity_compartments" "COMPARTMENTS" {
  compartment_id            = var.tenancy_ocid
  compartment_id_in_subtree = true
  filter {
    name   = "name"
    values = [var.linux_compute_instance_compartment_name]
  }
}

data "oci_identity_compartments" "NWCOMPARTMENTS" {
  compartment_id            = var.tenancy_ocid
  compartment_id_in_subtree = true
  filter {
    name   = "name"
    values = [var.linux_compute_network_compartment_name]
  }
}

data "oci_core_vcns" "VCN" {
  compartment_id = local.nw_compartment_id
  filter {
    name   = "display_name"
    values = [var.vcn_display_name]
  }
}



/********** Subnet Accessors **********/

data "oci_core_subnets" "PUBLICSUBNET" {
  compartment_id = local.nw_compartment_id
  vcn_id         = local.vcn_id
  filter {
    name   = "display_name"
    values = [var.public_network_subnet_name]
  }
}

data "oci_core_subnets" "PRIVATESUBNET" {
  compartment_id = local.nw_compartment_id
  vcn_id         = local.vcn_id
  filter {
    name   = "display_name"
    values = [var.private_network_subnet_name]
  }
}

data "oci_core_network_security_groups" "NSG" {
  compartment_id = local.nw_compartment_id
  vcn_id         = local.vcn_id


  filter {
    name   = "display_name"
    values = ["${var.compute_nsg_name}"]
  }

}

data "oci_core_volume_backup_policies" "BACKUPPOLICYISCSI" {
  filter {
    name = "display_name"

    values = [var.backup_policy_level]
  }
}

locals {

  # Subnet OCID local accessors
  public_subnet_ocid = length(data.oci_core_subnets.PUBLICSUBNET.subnets) > 0 ? data.oci_core_subnets.PUBLICSUBNET.subnets[0].id : null

  private_subnet_ocid = length(data.oci_core_subnets.PRIVATESUBNET.subnets) > 0 ? data.oci_core_subnets.PRIVATESUBNET.subnets[0].id : null

  # Compartment OCID Local Accessor
  compartment_id    = lookup(data.oci_identity_compartments.COMPARTMENTS.compartments[0], "id")
  nw_compartment_id = lookup(data.oci_identity_compartments.NWCOMPARTMENTS.compartments[0], "id")

  # VCN OCID Local Accessor
  vcn_id = lookup(data.oci_core_vcns.VCN.virtual_networks[0], "id")

  backup_policy_iscsi_disk_id = data.oci_core_volume_backup_policies.BACKUPPOLICYISCSI.volume_backup_policies[0].id

  # NSG OCID Local Accessor
  nsg_id = length(data.oci_core_network_security_groups.NSG.network_security_groups) > 0 ? data.oci_core_network_security_groups.NSG.network_security_groups[0].id : ""

  # Command aliases for format and mounting iscsi disks
  iscsiadm = "sudo iscsiadm"
  fdisk    = "(echo n; echo p; echo '1'; echo ''; echo ''; echo 't';echo '8e'; echo w) | sudo /sbin/fdisk "
  pvcreate = "sudo /sbin/pvcreate"
  vgcreate = "sudo /sbin/vgcreate"
  mkfs_xfs = "sudo /sbin/mkfs.xfs"

}