# Required
variable "odb_subnet_id" {
  type = string
  description = "The name of the ODB Subnet."
  default = null
}

variable "location" {
  type = string
  description = "GCP region where services are hosted."
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

variable "subnet_cidr_range" {
  type = string
  description = "The CIDR range used for the ODB Subnet."
  default = null
}

variable "subnet_purpose" {
  type = string
  description = "The CIDR range used for the ODB Subnet."
  default = "CLIENT_SUBNET"
}

variable "deletion_protection" {
  type = string
  description = "when set to true resources will be protected from accidental deletion"
  default = "true"
}