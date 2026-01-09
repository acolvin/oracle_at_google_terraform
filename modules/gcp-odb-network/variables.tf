# Required
variable "network_name" {
  type = string
  description = "The name of the VPC network used by the ODB Network"
  default = null
}

variable "vpc_project" {
  type = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default = null
}

variable "odb_network_id" {
  type = string
  description = "The name of the ODB Network."
  default = null
}

variable "location" {
  type = string
  description = "GCP region where services are hosted."
  default = null
}

variable "client_cidr_range" {
  type = string
  description = "The CIDR range used for the client ODB Subnet."
  default = null
}

variable "backup_cidr_range" {
  type = string
  description = "The CIDR range used for the backup ODB Subnet."
  default = null
}

variable "gcp_oracle_zone" {
  type = string
  description = "The zone where the ODB Network will reside"
  default = "Any"
}

variable "deletion_protection" {
  type = string
  description = "when set to true resources will be protected from accidental deletion"
  default = "true"
}