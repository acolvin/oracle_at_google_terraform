variable "peer_autonomous_database_id" {
  type = string
  description = "The name of the peer autonomous database"
  default = null
}

variable "peer_adb_location" {
  type = string
  description = "GCP region where services are hosted."
  default = null
}

variable "adb_project" {
  type = string
  description = "The ID of the project in which the ADB belongs. If it is not provided, the provider project is used."
  default = null
}

variable "peer_autonomous_database_display_name" {
  type = string
  description = "The display name of the peer autonomous database"
}

variable "vpc_project" {
  type = string
  description = "The ID of the project in which the ODB Network belongs. If it is not provided, the provider project is used."
  default = null
}

variable "odb_network_id" {
  type = string
  description = "The name of the ODB Network."
  default = null
}

variable "odb_subnet_id" {
  type = string
  description = "Name of the ODB Subnet."
  default = null
}

variable "license_type" {
  type = string
  description = "Whether you are using BYOL or boying a license-included SKU. Options are LICENSE_INCLUDED and BRING_YOUR_OWN_LICENSE."
  default = "LICENSE_INCLUDED"
}

variable "source_adb_id" {
  type = string
  description = "ID of the source autonomous database"
  default = null
}

variable "backup_replication_enabled" {
  type = string
  description = "Set to true if you want to replicate backups to the peer region"
  default = "false"
}

variable "deletion_protection" {
  type = string
  description = "when set to true resources will be protected from accidental deletion"
  default = "true"
}
