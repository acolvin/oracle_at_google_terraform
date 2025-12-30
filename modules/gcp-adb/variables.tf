# Required
variable "autonomous_database_id" {
  type = string
  description = "The name of the autonomous database"
}

variable "adb_admin_pw" {
  type = string
  description = "The admin password of your Autonomous Database"
}

variable "location" {
  type = string
  description = "GCP region where services are hosted."
}

variable "adb_project" {
  type = string
  description = "The ID of the project in which the ADB belongs. If it is not provided, the provider project is used."
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

variable "ecpu_count" {
  type = string
  description = "The number of ECPUs available to my instance"
  default = "2"
}

variable "data_storage_size_gb" {
  type = string
  description = "Number of gigabytes of storage to provision for ADB. Used with OLTP, AJD, APEX workload types"
  default = "20"
}

variable "data_storage_size_tb" {
  type = string
  description = "Number of terabytes of storage to provision for ADB. Used with DW workload type"
  default = null
}

variable "db_version" {
  type = string
  description = "database version - either 19c or 23ai"
  default = "19c"
}

variable "workload_type" {
  type = string
  description = "The workload type of the cluster, either OLTP, DW, AJD, APEX"
  default = "OLTP"
}

variable "db_edition" {
  type = string
  description = "database edition - only used when license_type is set to BRING_YOUR_OWN_LICENSE"
  default = "ENTERPRISE_EDITION"
}

variable "license_type" {
  type = string
  description = "Whether you are using BYOL or boying a license-included SKU. Options are LICENSE_INCLUDED and BRING_YOUR_OWN_LICENSE."
  default = "LICENSE_INCLUDED"
}

variable "backup_retention_period_days" {
  type = string
  description = "Number of days that automatic backups should be stored"
  default = null
}

variable "is_auto_scaling_enabled" {
  type = string
  description = "Set to true to enable CPU auto-scaling"
  default = "false"
}

variable "is_storage_auto_scaling_enabled" {
  type = string
  description = "Set to true to enable storage auto-scaling"
  default = "false"
}

variable "deletion_protection" {
  type = string
  description = "when set to true resources will be protected from accidental deletion"
  default = "true"
}
