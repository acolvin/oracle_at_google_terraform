### Created by andycolvin@google.com
## Works in my tests, you break it, you buy it

resource "google_oracle_database_db_system" "db_system"{
    db_system_id    = var.db_system_id
    display_name    = var.db_system_id
    location        = var.location
    gcp_oracle_zone = var.gcp_oracle_zone
    project         = var.dbsystem_project
    odb_network     = "projects/${var.vpc_project}/locations/${var.location}/odbNetworks/${var.odb_network_id}"
    odb_subnet      = "projects/${var.vpc_project}/locations/${var.location}/odbNetworks/${var.odb_network_id}/odbSubnets/${var.odb_network_id}-c1"
    properties {
        ssh_public_keys              = var.ssh_public_keys
        compute_count                = var.ecpu_core_count
        hostname_prefix              = var.hostname_prefix
        compute_model                = "ECPU"
        data_storage_size_gb         = var.data_storage_size_gb
        shape                        = "VM.Standard.x86"
        initial_data_storage_size_gb = var.initial_data_storage_size_gb
        database_edition             = var.db_edition
        license_model                = var.license_type
        db_home {
            db_version = var.db_version
            database {
                db_name             = var.db_name
                db_unique_name      = var.db_unique_name
                admin_password      = var.admin_pw
                tde_wallet_password = var.tde_pw
                database_id         = var.db_id
            }
            is_unified_auditing_enabled = var.enable_unified_auditing
        }
    }
  timeouts {
    create = "120m"
  }
  deletion_protection = var.deletion_protection
}