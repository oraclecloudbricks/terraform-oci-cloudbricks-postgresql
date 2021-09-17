# OCI Cloud Bricks: PostgreSQL

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=oracle-devrel_terraform-oci-cloudbricks-postgresql)](https://sonarcloud.io/dashboard?id=oracle-devrel_terraform-oci-cloudbricks-postgresql)

## Introduction
The following brick contains the logic to provision a PostgreSQL database in a highly available architecture. This architecture makes use of up to 3 instance in a master and standby configuration with streaming replication.

## Reference Architecture
The following is the reference architecture associated to this brick

![Reference Architecture]()


### Prerequisites
- Pre-baked Artifact and Network Compartments
- Pre-baked VCN

# Sample tfvar file

If using hotstandby instances and fixed shapes.

```shell
######################################## COMMON VARIABLES ######################################
region           = "re-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
user_ocid        = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
######################################## COMMON VARIABLES ######################################
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
ssh_public_key                          = "/absolute/path/to/api/key/your_ssh_public_key.pub"
ssh_private_key                         = "/absolute/path/to/api/key/your_ssh_private_key"
compute_nsg_name                        = "MY_NSG"
linux_compute_instance_compartment_name = "MY_ARTIFACT_COMPARTMENT"
linux_compute_network_compartment_name  = "MY_NETWORK_COMPARTMENT"
private_network_subnet_name             = "MY_PRIVATE_SUBNET"
vcn_display_name                        = "MY_VCN"

postgresql_replicat_username = "replicator"
postgresql_password          = "MY_DATABASE_PASSWORD"
postgresql_version           = "13"
database_size_in_gb          = "50"
database_vpus_per_gb         = "10"
database_backup_policy_level = "gold"
instance_backup_policy_level = "bronze"

postgresql_master_name          = "MY_MASTER_INSTANCE_NAME"
postgresql_master_ad            = "aBCD:RE-REGION-1-AD-1"
postgresql_master_fd            = "FAULT-DOMAIN-1"
postgresql_master_shape         = "VM.Standard2.2"

postgresql_hotstandby_is_flex_shape = false
postgresql_hotstandby_shape         = "VM.Standard2.1"

postgresql_deploy_hotstandby1 = true
postgresql_standyby1_name     = "MY_HOTSTANDBY1_INSTANCE_NAME"
postgresql_hotstandby1_ad     = "aBCD:RE-REGION-1-AD-2"
postgresql_hotstandby1_fd     = "FAULT-DOMAIN-1"

postgresql_deploy_hotstandby2 = true
postgresql_standyby2_name     = "MY_HOTSTANDBY2_INSTANCE_NAME"
postgresql_hotstandby2_ad     = "aBCD:RE-REGION-1-AD-3"
postgresql_hotstandby2_fd     = "FAULT-DOMAIN-1"
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
```

If using hotstandby instances and flex shapes.

```shell
######################################## COMMON VARIABLES ######################################
region           = "re-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
user_ocid        = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
######################################## COMMON VARIABLES ######################################
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
ssh_public_key                          = "/absolute/path/to/api/key/your_ssh_public_key.pub"
ssh_private_key                         = "/absolute/path/to/api/key/your_ssh_private_key"
compute_nsg_name                        = "MY_NSG"
linux_compute_instance_compartment_name = "MY_ARTIFACT_COMPARTMENT"
linux_compute_network_compartment_name  = "MY_NETWORK_COMPARTMENT"
private_network_subnet_name             = "MY_PRIVATE_SUBNET"
vcn_display_name                        = "MY_VCN"

postgresql_replicat_username = "replicator"
postgresql_password          = "MY_DATABASE_PASSWORD"
postgresql_version           = "13"
database_size_in_gb          = "50"
database_vpus_per_gb         = "10"
database_backup_policy_level = "gold"
instance_backup_policy_level = "bronze"

postgresql_master_name          = "MY_MASTER_INSTANCE_NAME"
postgresql_master_ad            = "aBCD:RE-REGION-1-AD-1"
postgresql_master_fd            = "FAULT-DOMAIN-1"
postgresql_master_is_flex_shape = true
postgresql_master_shape         = "VM.Standard.E3.Flex"
postgresql_master_ocpus         = "2"
postgresql_master_memory_in_gb  = "32"

postgresql_hotstandby_is_flex_shape = true
postgresql_hotstandby_shape         = "VM.Standard.E3.Flex"
postgresql_hotstandby_ocpus         = "1"
postgresql_hotstandby_memory_in_gb  = "16"

postgresql_deploy_hotstandby1 = true
postgresql_standyby1_name     = "MY_HOTSTANDBY1_INSTANCE_NAME"
postgresql_hotstandby1_ad     = "aBCD:RE-REGION-1-AD-2"
postgresql_hotstandby1_fd     = "FAULT-DOMAIN-1"

postgresql_deploy_hotstandby2 = true
postgresql_standyby2_name     = "MY_HOTSTANDBY2_INSTANCE_NAME"
postgresql_hotstandby2_ad     = "aBCD:RE-REGION-1-AD-3"
postgresql_hotstandby2_fd     = "FAULT-DOMAIN-1"
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
```

If using just a master instance and fixed shapes.

```shell
######################################## COMMON VARIABLES ######################################
region           = "re-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
user_ocid        = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
######################################## COMMON VARIABLES ######################################
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
ssh_public_key                          = "/absolute/path/to/api/key/your_ssh_public_key.pub"
ssh_private_key                         = "/absolute/path/to/api/key/your_ssh_private_key"
compute_nsg_name                        = "MY_NSG"
linux_compute_instance_compartment_name = "MY_ARTIFACT_COMPARTMENT"
linux_compute_network_compartment_name  = "MY_NETWORK_COMPARTMENT"
private_network_subnet_name             = "MY_PRIVATE_SUBNET"
vcn_display_name                        = "MY_VCN"

postgresql_password          = "MY_DATABASE_PASSWORD"
postgresql_version           = "13"
database_size_in_gb          = "50"
database_vpus_per_gb         = "10"
database_backup_policy_level = "gold"
instance_backup_policy_level = "bronze"

postgresql_master_name          = "MY_MASTER_INSTANCE_NAME"
postgresql_master_ad            = "aBCD:RE-REGION-1-AD-1"
postgresql_master_fd            = "FAULT-DOMAIN-1"
postgresql_master_shape         = "VM.Standard2.2"
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
```

If using just a master instance and a flex shape.

```shell
######################################## COMMON VARIABLES ######################################
region           = "re-region-1"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
user_ocid        = "ocid1.tenancy.oc1..aaaaaaaabcedfghijklmonoprstuvwxyz"
fingerprint      = "fo:oo:ba:ar:ba:ar"
private_key_path = "/absolute/path/to/api/key/your_api_key.pem"
######################################## COMMON VARIABLES ######################################
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
ssh_public_key                          = "/absolute/path/to/api/key/your_ssh_public_key.pub"
ssh_private_key                         = "/absolute/path/to/api/key/your_ssh_private_key"
compute_nsg_name                        = "MY_NSG"
linux_compute_instance_compartment_name = "MY_ARTIFACT_COMPARTMENT"
linux_compute_network_compartment_name  = "MY_NETWORK_COMPARTMENT"
private_network_subnet_name             = "MY_PRIVATE_SUBNET"
vcn_display_name                        = "MY_VCN"

postgresql_password          = "MY_DATABASE_PASSWORD"
postgresql_version           = "13"
database_size_in_gb          = "50"
database_vpus_per_gb         = "10"
database_backup_policy_level = "gold"
instance_backup_policy_level = "bronze"

postgresql_master_name          = "MY_MASTER_INSTANCE_NAME"
postgresql_master_ad            = "aBCD:RE-REGION-1-AD-1"
postgresql_master_fd            = "FAULT-DOMAIN-1"
postgresql_master_is_flex_shape = true
postgresql_master_shape         = "VM.Standard.E3.Flex"
postgresql_master_ocpus         = "2"
postgresql_master_memory_in_gb  = "32"
######################################## ARTIFACT SPECIFIC VARIABLES ######################################
```

### Variable Specific Conisderions
- Compute ssh keys to later log into instances. Paths to the keys should be provided in variables `ssh_public_key` and `ssh_private_key`.
- Variable `compute_nsg_name` is an optional network security group that can be attached.
- Variable `postgresql_replicat_username` is used as a login name to setup replication. This doesn't need to be supplied in a master only configuration.
- Variable `postgresql_version` can be any of the supported version of PostgreSQL at the time of making this brick (`9.6`, `10`, `11`, `12` and `13`).
- Variable `database_size_in_gb` is the size of the attached ISCSI disks to store the PostgreSQL database on. This can be between `50` and `32768`.
- Variable `database_vpus_per_gb` is the number of volume performance units to be applied to the attached ISCSI disks. The value must be between `0` and `120` and be multiple of 10.
- Variable `database_backup_policy_level` specifies the name of the backup policy used on the attached database ISCSI disks.
- Variable `instance_backup_policy_level` specifies the name of the backup policy used on the instance boot volumes.
- Flex Shapes:
  - Variable `postgresql_master_is_flex_shape` should be defined as true when the master instance is a flex shape. The variables `postgresql_master_ocpus` and `postgresql_master_memory_in_gb` should then also be defined. Do not use any of these variables at all when using a standard shape as they are not needed and assume sensible defaults.
  - Variable `postgresql_hotstandby_is_flex_shape` should be defined as true when the standby instances are a flex shape. The variables `postgresql_hotstandby_ocpus` and `postgresql_hotstandby_memory_in_gb` should then also be defined. Do not use any of these variables at all when using a standard shape as they are not needed and assume sensible defaults.
- Standby Instances:
  - Variable `postgresql_deploy_hotstandby1` should be defined as true when a hotstandby1 is needed. The variables `postgresql_standyby1_name`, `postgresql_hotstandby1_ad` and `postgresql_hotstandby1_fd` then should also be defined.
  - Variable `postgresql_deploy_hotstandby2` should be defined as true when a hotstandby2 is needed. The variables `postgresql_standyby2_name`, `postgresql_hotstandby2_ad` and `postgresql_hotstandby2_fd` then should also be defined.

### Sample provider
The following is the base provider definition to be used with this module

```shell
terraform {
  required_version = ">= 0.13.5"
}
provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  disable_auto_retries = "true"
}

provider "oci" {
  alias        = "home"
  region       = data.oci_identity_region_subscriptions.home_region_subscriptions.region_subscriptions[0].region_name
  tenancy_ocid = var.tenancy_ocid  
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  disable_auto_retries = "true"
}
```




## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2021 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.
