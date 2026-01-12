### Created by andycolvin@google.com
## Works in my tests, you break it, you buy it

provider "google" {
  project = local.adb_project
  region  = local.location
  default_labels = {
    tf-module = "odbg-module"
  }
}

locals {
  # ADB Instance Configuration
  location                           = "us-west3"
  adb_project                        = "my-adb-project"
  autonomous_database_id             = "myadb1"
  vpc_project                        = "my-network-host-project"
  odb_network_id                     = "tf-slc-odbnetwork"
  ecpu_count                         = "2"
  data_storage_size_gb               = "20" #set if workload_type = OLTP, APEX, or AJD
  data_storage_size_tb               = null #set if workload_type = DW
  db_version                         = "23ai"
  workload_type                      = "OLTP"
  db_edition                         = null # set to ENTERPRISE_EDITION or STANDARD_EDITION if adb_license_type is set to BRING_YOUR_OWN_LICENSE
  adb_license_type                   = "BRING_YOUR_OWN_LICENSE"
  backup_retention_period_days       = "1"
  is_auto_scaling_enabled            = "false"
  is_storage_auto_scaling_enabled    = "false"
  adb_deletion_protection            = "true"
}

resource "random_password" "adb_password" {
  length           = 16
  special          = true
  override_special = "!#^*"
}

# ADB Instance
module "adb" {
  source = "../../modules/gcp-adb"

  # Required
  location                        = local.location
  adb_project                     = local.adb_project
  autonomous_database_id          = local.autonomous_database_id
  adb_admin_pw                    = random_password.adb_password.result
  vpc_project                     = local.vpc_project
  odb_network_id                  = local.odb_network_id
  odb_subnet_id                   = "${local.odb_network_id}-c1"
  ecpu_count                      = local.ecpu_count
  data_storage_size_gb            = local.data_storage_size_gb
  data_storage_size_tb            = local.data_storage_size_tb
  db_version                      = local.db_version
  workload_type                   = local.workload_type
  db_edition                      = local.db_edition
  license_type                    = local.adb_license_type
  backup_retention_period_days    = local.backup_retention_period_days
  is_auto_scaling_enabled         = local.is_auto_scaling_enabled
  is_storage_auto_scaling_enabled = local.is_storage_auto_scaling_enabled
  deletion_protection             = local.adb_deletion_protection
}
