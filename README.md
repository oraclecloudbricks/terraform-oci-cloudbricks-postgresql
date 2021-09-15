# OCI Cloud Bricks: PostgreSQL

[![License: UPL](https://img.shields.io/badge/license-UPL-green)](https://img.shields.io/badge/license-UPL-green) [![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=oracle-devrel_terraform-oci-cloudbricks-postgresql)](https://sonarcloud.io/dashboard?id=oracle-devrel_terraform-oci-cloudbricks-postgresql)

## Introduction
The following is the reference architecture associated to the brick

![Reference Architecture]()


## Pre-requisites
MISSING

## Sample tfvar file
```shell
# Authentication
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaoqdygmiidrabhv3y4hkr3rb3z6dpmgotvq2scffra6jt7rubresa"
user_ocid        = "ocid1.user.oc1..aaaaaaaafl42rhkw624h4os6n2ulcfxjjn2ylqsanhgtcph7j7owirzj6gya"
fingerprint      = "9a:9e:13:cf:94:6e:2c:b9:54:d2:60:0d:e4:14:8b:5e"
private_key_path = "/home/opc/my_keys/oci_api_key.pem"
# Region
region = "sa-santiago-1"

# Availablity Domain 
availablity_domain_name = "oDQF:SA-SANTIAGO-1-AD-1" # for example GrCH:US-ASHBURN-AD-1

# PostgreSQL Password
postgresql_password = "345database5678password0238"

# PostgreSQL Version (supported versions 9.6, 10, 11, 12, 13)
postgresql_version = "13"

# First HotStandby 
postgresql_hotstandby1_ad = "oDQF:SA-SANTIAGO-1-AD-1" # for example GrCH:US-ASHBURN-AD-2
postgresql_hotstandby1_fd = "FAULT-DOMAIN-2"          # for example FAULT-DOMAIN-2

# Second HotStandby 
postgresql_hotstandby2_ad = "oDQF:SA-SANTIAGO-1-AD-1" # for example GrCH:US-ASHBURN-AD-3
postgresql_hotstandby2_fd = "FAULT-DOMAIN-3"          # for example FAULT-DOMAIN-3

compute_nsg_name                        = "NSG_PUBLIC_ACCESS"
linux_compute_instance_compartment_name = "DALQUINT_HUB"
linux_compute_network_compartment_name  = "DALQUINT_HUB"
private_network_subnet_name             = "dalquint_hub_pvt_subnet"
public_network_subnet_name              = "dalquint_hub_pub_subnet"
vcn_display_name                        = "DALQUINT_HUB_VCN"

ssh_public_key  = "/home/opc/.ssh/OCI_KEYS/SSH/auto_ssh_id_rsa.pub"
ssh_private_key = "/home/opc/.ssh/OCI_KEYS/SSH/auto_ssh_id_rsa"
```

## Notes/Issues
MISSING

## URLs
* Nothing at this time

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2021 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.
