# Required
variable "db_system_id" {
  type = string
  description = "The name of the DB system"
}

variable "location" {
  type = string
  description = "GCP region where services are hosted."
}

variable "gcp_oracle_zone" {
  type = string
  description = "Oracle Database@Google Cloud zone where services are hosted."
}

variable "dbsystem_project" {
  type = string
  description = "The ID of the project in which the DB system belongs. If it is not provided, the provider project is used."
  default = ""
}

variable "vpc_project" {
  type = string
  description = "The ID of the project in which the ODB Network belongs. If it is not provided, the provider project is used."
  default = ""
}

variable "odb_network_id" {
  type = string
  description = "The name of the ODB Network."
}

variable "ssh_public_keys" {
    type = set(string)
    description = "SSH keys for the DB system"
}

variable "ecpu_core_count" {
  type = string
  description = "The number of ECPUs available to the DB system. Minimum value is 4 and must be a multiple of 4"
  default = "4"
}

variable "hostname_prefix" {
    type = string
    description = "The prefix used for the DB system hostname"
}

variable "data_storage_size_gb" {
  type = string
  description = "How much storage should be allocated to the DB system for database files. Use this field to increase the size allocated to a DB system. Allowed values are 256, 512, 1024, 2048, 4096, 8192, 16384, 24576, 32768, and 40960"
  default = "256"
}

variable "initial_data_storage_size_gb" {
  type = string
  description = "Used during provisioning to determine database storage. To change storage allocation after provisioning set data_storage_size_gb. Allowed values are 256, 512, 1024, 2048, 4096, 8192, 16384, 24576, 32768, and 40960"
  default = "256"
}

variable "db_edition" {
  type = string
  description = "database version - either 19c or 23ai"
  default = "ENTERPRISE_EDITION"
}

variable "license_type" {
  type = string
  description = "Whether you are using BYOL or boying a license-included SKU. Options are LICENSE_INCLUDED and BRING_YOUR_OWN_LICENSE."
  default = "LICENSE_INCLUDED"
}

variable "db_version" {
  type = string
  description = "The database version. Use a generic version or specify a patch level. Common versions are 19.0.0.0 and 23.26.0.0"
  default = "19.0.0.0"
}

variable "db_name" {
    type = string
    description = "The database name assigned to the container database"
}

variable "db_unique_name" {
    type = string
    description = "The unique name for the container database"
}

variable "admin_pw" {
    type = string
    description = "The administrator password for the container database"
}

variable "tde_pw" {
    type = string
    description = "The password used for transparent data encryption on the container database"
}

variable "db_id" {
    type = string
    description = "A unique identifier for the database that is not used for any other databases in the project"
}

variable "enable_unified_auditing" {
    type = string
    description = "Define whether to use unified auditing on the database home"
    default = "true"
}

variable "deletion_protection" {
  type = string
  description = "when set to true resources will be protected from accidental deletion"
  default = "true"
}
