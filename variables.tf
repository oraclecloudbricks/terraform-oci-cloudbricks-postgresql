## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "availablity_domain_name" {}

variable "show_advanced" {
  default = false
}

variable "create_in_private_subnet" {
  default = true
}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.2"
}

variable "ssh_public_key" {
}

variable "postgresql_vcn_cidr" {
  default = "10.1.0.0/16"
}

variable "postgresql_subnet_cidr" {
  default = "10.1.20.0/24"
}

variable "bastion_subnet_cidr" {
  default = "10.1.21.0/24"
}

variable "postgresql_instance_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "postgresql_instance_flex_shape_ocpus" {
  default = 1
}

variable "postgresql_instance_flex_shape_memory" {
  default = 10
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "7.9"
}

variable "postgresql_master_fd" {
  default = "FAULT-DOMAIN-1"
}

variable "postgresql_replicat_username" {
  default = "replicator"
}

variable "postgresql_password" {
  default = ""
}

variable "postgresql_version" {
  default = "13"
}

variable "postgresql_deploy_hotstandby1" {
  default = true
}

variable "postgresql_hotstandby1_fd" {
  default = "FAULT-DOMAIN-2"
}

variable "postgresql_hotstandby1_ad" {
  default = ""
}

variable "postgresql_hotstandby1_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "postgresql_hotstandby1_flex_shape_ocpus" {
  default = 1
}

variable "postgresql_hotstandby1_flex_shape_memory" {
  default = 10
}

variable "postgresql_deploy_hotstandby2" {
  default = true
}

variable "postgresql_hotstandby2_fd" {
  default = "FAULT-DOMAIN-3"
}

variable "postgresql_hotstandby2_ad" {
  default = ""
}

variable "postgresql_hotstandby2_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "postgresql_hotstandby2_flex_shape_ocpus" {
  default = 1
}

variable "postgresql_hotstandby2_flex_shape_memory" {
  default = 10
}

# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex"
  ]
}

# Checks if is using Flexible Compute Shapes
locals {
  is_flexible_postgresql_instance_shape    = contains(local.compute_flexible_shapes, var.postgresql_instance_shape)
  is_flexible_postgresql_hotstandby1_shape = contains(local.compute_flexible_shapes, var.postgresql_hotstandby1_shape)
  is_flexible_postgresql_hotstandby2_shape = contains(local.compute_flexible_shapes, var.postgresql_hotstandby2_shape)
}


variable "linux_compute_instance_compartment_name" {
  description = "Defines the compartment name where the infrastructure will be created"
}

variable "linux_compute_network_compartment_name" {
  description = "Defines the compartment where the Network is currently located"
}

variable "vcn_display_name" {
  description = "VCN Display name to execute lookup"
}

variable "public_network_subnet_name" {
  description = "Defines the subnet display name where this resource will be created at"
}

variable "private_network_subnet_name" {
  description = "Defines the subnet display name where this resource will be created at"
}

variable "compute_nsg_name" {
  description = "Name of the NSG associated to the compute"
}


variable "ssh_public_is_path" {
  default = true

}

variable "ssh_private_key" {

}


variable "backup_policy_level" {
  description = "Backup policy level for ISCSI disks"
  default     = "bronze"
}

variable "disk_size_in_gb" {
  description = "Disk Capacity for Database"
  default     = "85"

}

variable "vpus_per_gb" {
  default = 10
}