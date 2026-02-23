# Copyright 2026 Andy Colvin, Google
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
  default_labels = {
    tf-module = "odbg-module"
  }
}

locals {
  # ADB Instance Configuration
  peer_adb_location                  = "us-west3"
  primary_adb_location               = "us-central1"
  adb_project                        = "my-adb-project"
  peer_autonomous_database_id        = "mypeeradb1"
  primary_autonomous_database_id     = "myprimaryadb1"
  vpc_project                        = "my-network-host-project"
  odb_network_id                     = "tf-slc-odbnetwork"
  backup_replication_enabled         = "false"
  adb_deletion_protection            = "true"
}

data "google_oracle_database_autonomous_database" "primary-adb" {
  location = local.primary_adb_location
  project = local.adb_project
  autonomous_database_id = local.primary_autonomous_database_id
}

# ADB Instance
module "peer-adb" {
  source = "../../modules/gcp-adb-standby"

  # Required
  peer_autonomous_database_id           = local.peer_autonomous_database_id
  peer_adb_location                     = local.peer_adb_location
  adb_project                           = local.adb_project
  peer_autonomous_database_display_name = local.peer_autonomous_database_id
  vpc_project                           = local.vpc_project
  odb_network_id                        = local.odb_network_id
  odb_subnet_id                         = "${local.odb_network_id}-c1"
  source_adb_id                         = data.google_oracle_database_autonomous_database.primary-adb.id
  backup_replication_enabled            = local.backup_replication_enabled
  deletion_protection                   = local.adb_deletion_protection
}
