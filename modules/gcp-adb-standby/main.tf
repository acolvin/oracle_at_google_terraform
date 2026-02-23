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

resource "google_oracle_database_autonomous_database" "standby-adb"{
  autonomous_database_id = var.peer_autonomous_database_id
  location               = var.peer_adb_location
  project                = var.adb_project
  display_name           = var.peer_autonomous_database_display_name
  odb_network            = "projects/${var.vpc_project}/locations/${var.peer_adb_location}/odbNetworks/${var.odb_network_id}"
  odb_subnet             = "projects/${var.vpc_project}/locations/${var.peer_adb_location}/odbNetworks/${var.odb_network_id}/odbSubnets/${var.odb_subnet_id}"
  source_config {
    autonomous_database                   = var.source_adb_id
    automatic_backups_replication_enabled = var.backup_replication_enabled
    }
  deletion_protection = var.deletion_protection
  lifecycle {
    ignore_changes = [
      properties[0].compute_count,
      properties[0].data_storage_size_gb,
      properties[0].data_storage_size_tb,
      properties[0].db_version,
      properties[0].db_edition
    ]
  }
}
