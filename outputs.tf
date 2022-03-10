# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# output.tf 
#
# Purpose: The following file passes all outputs of the brick

output "PostgreSQL_Master" {
  description = "PostgreSQL Master Instance"
  value       = oci_core_instance.postgresql_master
}

output "PostgreSQL_Username" {
  value = "postgres"
}
