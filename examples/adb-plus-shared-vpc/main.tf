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
  # ODB Network Configuration
  network_deletion_protection        = "true"
  location                           = "us-west3"
  vpc_project                        = "my-network-host-project"
  network_name                       = "default"
  odb_network_id                     = "tf-slc-odbnetwork"
  odb_subnet_id                      = "tf-slc-odbsubnet"
  client_cidr_range                  = "172.16.119.0/25"
  backup_cidr_range                  = "172.16.119.128/25"
  gcp_oracle_zone                    = "us-west3-a-r1"

  # ADB Instance Configuration
  adb_deletion_protection            = "true"
  adb_project                        = "my-adb-project"
  autonomous_database_id             = "myadb1"
  adb_admin_pw                       = "Google123456"
  ecpu_count                         = "2"
  data_storage_size_gb               = "20"
  db_version                         = "23ai"
  workload_type                      = "OLTP"
  db_edition                         = "ENTERPRISE_EDITION"
  adb_license_type                   = "LICENSE_INCLUDED"
}

resource "random_password" "adb_password" {
  length           = 16
  special          = true
  override_special = "!#^*"
}

data "google_compute_network" "this" {
  name     = local.network_name
  project  = local.vpc_project
}

# ODB Network
module "odb-network" {
  source = "../../modules/gcp-odb-network"
  depends_on = [ data.google_compute_network.this ]

  # Required
  location               = local.location
  vpc_project            = local.vpc_project
  network_name           = local.network_name
  gcp_oracle_zone        = local.gcp_oracle_zone
  odb_network_id         = local.odb_network_id
  odb_subnet_id          = local.odb_subnet_id
  client_cidr_range      = local.client_cidr_range
  backup_cidr_range      = local.backup_cidr_range
  deletion_protection    = local.network_deletion_protection
}

module "adb" {
  source = "../../modules/gcp-adb"
  depends_on = [ module.odb-network ]

  # Required
  location                        = local.location
  adb_project                     = local.adb_project
  autonomous_database_id          = local.autonomous_database_id
  adb_admin_pw                    = random_password.adb_password.result
  vpc_project                     = local.vpc_project
  odb_network_id                  = local.odb_network_id
  ecpu_count                      = local.ecpu_count
  data_storage_size_gb            = local.data_storage_size_gb
  db_version                      = local.db_version
  workload_type                   = local.workload_type
  db_edition                      = local.db_edition
  license_type                    = local.adb_license_type
  deletion_protection             = local.adb_deletion_protection
}
