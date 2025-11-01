### Created by andycolvin@google.com
## Works in my tests, you break it, you buy it

provider "google" {
  project = local.dbsystem_project
  region  = local.location
  default_labels = {
    tf-module = "odbg-module"
  }
}

locals {
  # ODB Network Configuration
  network_deletion_protection        = "true"
  location                           = "us-east4"
  vpc_project                        = "my-network-host-project"
  network_name                       = "default"
  odb_network_id                     = "tf-slc-odbnetwork"
  odb_subnet_id                      = "tf-slc-odbsubnet"
  client_cidr_range                  = "172.16.119.0/25"
  backup_cidr_range                  = "172.16.119.128/25"
  gcp_oracle_zone                    = "us-west3-a-r1"

  # DB System Configuration
  db_system_id                 = "mydb1"
  dbsystem_project             = "my-oracle-project"
  ssh_public_keys              = "ssh-key fjslkdfsjdklsdfVSDKVKVDF"
  ecpu_core_count              = "4"
  hostname_prefix              = "mydb1"
  data_storage_size_gb         = "256"
  initial_data_storage_size_gb = "256"
  db_edition                   = "ENTERPRISE_EDITION"
  license_type                 = "BRING_YOUR_OWN_LICENSE"
  db_version                   = "23.26.0.0"
  db_name                      = "mycdb1"
  db_unique_name               = "mycdb1"
  admin_pw                     = random_password.database_password.result
  tde_pw                       = random_password.database_password.result
  db_id                        = "mycdb1"
  enable_unified_auditing      = "true"
  basedb_deletion_protection   = "true"
}

resource "random_password" "database_password" {
  length           = 16
  special          = true
  override_special = "!#^_*"
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

module "basedb" {
  source = "../../modules/gcp-dbsystem"
  depends_on = [ module.odb-network ]

  # Required
  db_system_id                 = local.db_system_id
  location                     = local.location
  gcp_oracle_zone              = local.gcp_oracle_zone
  dbsystem_project             = local.dbsystem_project
  odb_network_id               = local.odb_network_id
  vpc_project                  = local.vpc_project
  ssh_public_keys              = [local.ssh_public_keys]
  ecpu_core_count              = local.ecpu_core_count
  hostname_prefix              = local.hostname_prefix
  data_storage_size_gb         = local.data_storage_size_gb
  initial_data_storage_size_gb = local.initial_data_storage_size_gb
  db_edition                   = local.db_edition
  license_type                 = local.license_type
  db_version                   = local.db_version
  db_name                      = local.db_name
  db_unique_name               = local.db_unique_name
  admin_pw                     = random_password.database_password.result
  tde_pw                       = random_password.database_password.result
  db_id                        = local.db_id
  enable_unified_auditing      = local.enable_unified_auditing
  deletion_protection          = local.basedb_deletion_protection
}