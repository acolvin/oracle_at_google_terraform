### Created by andycolvin@google.com
## Works in my tests, you break it, you buy it

resource "google_oracle_database_autonomous_database" "adb"{
  autonomous_database_id = var.autonomous_database_id
  location               = var.location
  project                = var.adb_project
  database               = var.autonomous_database_id
  display_name           = var.autonomous_database_id
  admin_password         = var.adb_admin_pw
  odb_network            = "projects/${var.vpc_project}/locations/${var.location}/odbNetworks/${var.odb_network_id}"
  odb_subnet             = "projects/${var.vpc_project}/locations/${var.location}/odbNetworks/${var.odb_network_id}/odbSubnets/${var.odb_network_id}-c1"
  properties {
    compute_count         = var.ecpu_count
    data_storage_size_gb  = var.data_storage_size_gb
    db_version            = var.db_version
    db_workload           = var.workload_type
    db_edition            = var.db_edition
    license_type          = var.license_type
    }
  deletion_protection = var.deletion_protection
}
