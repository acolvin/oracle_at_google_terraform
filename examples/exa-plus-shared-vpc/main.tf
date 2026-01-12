### Created by andycolvin@google.com
## Works in my tests, you break it, you buy it

provider "google" {
  project = local.exa_vm_project
  region  = local.location
  default_labels = {
    tf-module = "exa-module"
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
  
  # Exadata Infrastructure Configuration
  exadata_infra_deletion_protection  = "true"
  cloud_exadata_infrastructure_id    = "exa-tf-slc1"
  exa_infra_project                  = "my-exadata-infra-project"
  shape                              = "Exadata.X11M"
  compute_count                      = "2"
  storage_count                      = "3"
  
  # Exadata VM Cluster 1 Configuration
  exadata_vm_deletion_protection     = "true"
  exa_vm_project                     = "my-exadata-vm-project"
  cloud_vm_cluster_id                = "exa-vmc1"
  exa_license_type                   = "BRING_YOUR_OWN_LICENSE"
  gi_version                         = "23.0.0.0"
  cpu_core_count                     = "32"
  memory_size_gb                     = "60"
  db_node_storage_size_gb            = "120"
  hostname_prefix                    = "slc-vmc1"
  ssh_public_keys                    = "ssh-rsa key-data"
}


data "google_compute_network" "this" {
  name     = local.network_name
  project  = local.vpc_project
}

# ODB Network
module "odb-network" {
  source = "../../modules/gcp-odb-network"
  depends_on = [ data.google_compute_network.vpc-network ]

  # Required
  location               = local.location
  vpc_project            = local.vpc_project
  network_name           = local.network_name
  gcp_oracle_zone        = local.gcp_oracle_zone
  odb_network_id         = local.odb_network_id
  deletion_protection    = local.network_deletion_protection
}

# ODB Subnet
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

# ODB Subnet
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

module "exadata-infra" {
  source = "../../modules/gcp-exadata-infra"
  depends_on = [ module.odb-network ]

  location                        = local.location
  exa_infra_project               = local.exa_infra_project
  gcp_oracle_zone                 = local.gcp_oracle_zone
  cloud_exadata_infrastructure_id = local.cloud_exadata_infrastructure_id
  shape                           = local.shape
  compute_count                   = local.compute_count
  storage_count                   = local.storage_count
  deletion_protection             = local.exadata_infra_deletion_protection
}

module "vmcluster-1" {
  source = "../../modules/gcp-exadata-vmcluster"
  depends_on = [ module.exadata-infra ]

  # Required
  location                        = local.location
  exa_infra_project               = local.exa_infra_project
  exa_vm_project                  = local.exa_vm_project
  vpc_project                     = local.vpc_project
  odb_network_id                  = local.odb_network_id
  cloud_vm_cluster_id             = local.cloud_vm_cluster_id
  cloud_exadata_infrastructure_id = local.cloud_exadata_infrastructure_id
  gi_version                      = local.gi_version
  license_type                    = local.exa_license_type
  hostname_prefix                 = local.hostname_prefix
  cpu_core_count                  = local.cpu_core_count
  memory_size_gb                  = local.memory_size_gb
  db_node_storage_size_gb         = local.db_node_storage_size_gb
  ssh_public_keys                 = [local.ssh_public_keys]
  deletion_protection             = local.exadata_vm_deletion_protection
}
