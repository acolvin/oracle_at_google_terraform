### Created by andycolvin@google.com
## Works in my tests, you break it, you buy it

provider "google" {
  project = local.vpc_project
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
  client_cidr_range                  = "172.16.119.0/25"
  backup_cidr_range                  = "172.16.119.128/25"
  gcp_oracle_zone                    = "us-west3-a-r1"
  subnet_deletion_protection         = "true"
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
  client_cidr_range      = local.client_cidr_range
  backup_cidr_range      = local.backup_cidr_range
  deletion_protection    = local.network_deletion_protection
}

module "client-subnet" {
  source = "../../modules/gcp-odb-subnet"
  depends_on = [ module.odb-network ]

  # Required
  odb_subnet_id          = "${local.odb_network_id}-c1"
  location               = local.location
  vpc_project            = local.vpc_project
  odb_network_id         = local.odb_network_id
  subnet_cidr_range      = local.client_cidr_range
  subnet_purpose         = "CLIENT_SUBNET"
  deletion_protection    = local.subnet_deletion_protection
}

module "backup-subnet" {
  source = "../../modules/gcp-odb-subnet"
  depends_on = [ module.client-subnet ]

  # Required
  odb_subnet_id          = "${local.odb_network_id}-b1"
  location               = local.location
  vpc_project            = local.vpc_project
  odb_network_id         = local.odb_network_id
  subnet_cidr_range      = local.backup_cidr_range
  subnet_purpose         = "BACKUP_SUBNET"
  deletion_protection    = local.subnet_deletion_protection
}