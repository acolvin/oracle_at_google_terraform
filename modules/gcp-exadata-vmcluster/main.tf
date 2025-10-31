### Created by andycolvin@google.com
## Works in my tests, you break it, you buy it

data "google_oracle_database_cloud_exadata_infrastructure" "exadata_infrastructure"{
  location                        = var.location
  project                         = var.exa_infra_project
  cloud_exadata_infrastructure_id = var.cloud_exadata_infrastructure_id
}

data "google_oracle_database_db_servers" "db_servers"{
  depends_on                   = [ data.google_oracle_database_cloud_exadata_infrastructure.exadata_infrastructure ]
  location                     = var.location
  project                      = var.exa_infra_project
  cloud_exadata_infrastructure = var.cloud_exadata_infrastructure_id
}

resource "google_oracle_database_cloud_vm_cluster" "exadata_vm_cluster"{
  depends_on = [ data.google_oracle_database_cloud_exadata_infrastructure.exadata_infrastructure ]

  cloud_vm_cluster_id    = var.cloud_vm_cluster_id
  display_name           = var.cloud_vm_cluster_id
  location               = var.location
  project                = var.exa_vm_project
  exadata_infrastructure = "projects/${var.exa_infra_project}/locations/${var.location}/cloudExadataInfrastructures/${var.cloud_exadata_infrastructure_id}"
  odb_network            = "projects/${var.vpc_project}/locations/${var.location}/odbNetworks/${var.odb_network_id}"
  odb_subnet             = "projects/${var.vpc_project}/locations/${var.location}/odbNetworks/${var.odb_network_id}/odbSubnets/${var.odb_network_id}-c1"
  backup_odb_subnet      = "projects/${var.vpc_project}/locations/${var.location}/odbNetworks/${var.odb_network_id}/odbSubnets/${var.odb_network_id}-b1"
  properties {
    license_type            = var.license_type
    ssh_public_keys         = var.ssh_public_keys
    cpu_core_count          = var.cpu_core_count
    memory_size_gb          = var.memory_size_gb
    db_node_storage_size_gb = var.db_node_storage_size_gb
    db_server_ocids        = [data.google_oracle_database_db_servers.db_servers.db_servers.0.properties.0.ocid, data.google_oracle_database_db_servers.db_servers.db_servers.1.properties.0.ocid]
    data_storage_size_tb    = "2"
    gi_version              = var.gi_version
    hostname_prefix         = var.hostname_prefix
  }

  timeouts {
    create = "360m"
  }

  deletion_protection = var.deletion_protection
}