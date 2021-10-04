## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "PostgreSQL_Master" {
  description = "PostgreSQL Master Instance"
  sensitive = true
  value = oci_core_instance.postgresql_master
}

output "PostgreSQL_Username" {
  value = "postgres"
}
