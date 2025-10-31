### Created by andycolvin@google.com
## Works in my tests, you break it, you buy it

data "google_oracle_database_db_servers" "db_servers"{
    depends_on                   = [ google_oracle_database_cloud_exadata_infrastructure.exadata_infrastructure ]
    location                     = var.location
    project                      = var.exa_infra_project
    cloud_exadata_infrastructure = var.cloud_exadata_infrastructure_id
}

resource "google_oracle_database_cloud_exadata_infrastructure" "exadata_infrastructure"{
  cloud_exadata_infrastructure_id = var.cloud_exadata_infrastructure_id
  display_name                    = var.cloud_exadata_infrastructure_id
  location                        = var.location
  project                         = var.exa_infra_project
  gcp_oracle_zone                 = var.gcp_oracle_zone
  properties {
    shape         = var.shape
    compute_count = var.compute_count
    storage_count = var.storage_count
  }

  deletion_protection = var.deletion_protection
}