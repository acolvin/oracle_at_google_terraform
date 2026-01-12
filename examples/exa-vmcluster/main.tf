# Copyright 2025 Andy Colvin, Google
#
# Licensed under the Apache License, Version 2.0 (the "License").
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

provider "google" {
  project = local.exa_vm_project
  region  = local.location
  default_labels = {
    tf-module = "exa-module"
  }
}

locals {
  # ODB Network Configuration
  location                           = "us-west3"
  vpc_project                        = "my-network-host-project"
  network_name                       = "default"
  odb_network_id                     = "tf-slc-odbnetwork"
  
  # Exadata Infrastructure Configuration
  cloud_exadata_infrastructure_id    = "exa-tf-slc1"
  exa_infra_project                  = "my-exadata-infra-project"
  
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

data "google_oracle_database_cloud_exadata_infrastructure" "exa-infra"{
  project                         = local.exa_infra_project
  location                        = local.location
  cloud_exadata_infrastructure_id = local.cloud_exadata_infrastructure_id
}

module "vmcluster-1" {
  source = "../../modules/gcp-exadata-vmcluster"
  depends_on = [ data.google_oracle_database_cloud_exadata_infrastructure.exa-infra ]

  # Required
  location                        = local.location
  exa_infra_project               = local.exa_infra_project
  exa_vm_project                  = local.exa_vm_project
  vpc_project                     = local.vpc_project
  odb_network_id                  = local.odb_network_id
  odb_client_subnet_id            = "${local.odb_network_id}-c1"
  odb_backup_subnet_id            = "${local.odb_network_id}-b1"
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
