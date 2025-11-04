# Required
variable "location" {
  type = string
  description = "GCP region where services are hosted."
}

variable "exa_infra_project" {
  type = string
  description = "The ID of the project in which the Exadata infrastructure belongs. If it is not provided, the provider project is used."
  default = ""
}

variable "cloud_exadata_infrastructure_id" {
  type = string
  description = "The name of the Exadata infrastructure"
}

variable "cloud_vm_cluster_id" {
  type = string
  description = "The name of the Exadata VM Cluster."
}

variable "exa_vm_project" {
  type = string
  description = "The ID of the project in which the Exadata VM cluster belongs. If it is not provided, the provider project is used."
  default = ""
}

variable "vpc_project" {
    type = string
    description = "Project ID for the shared VPC"
}

variable "odb_network_id" {
  type = string
  description = "The name of the ODB Network."
}

variable "license_type" {
    type = string
    description = "either BRING_YOUR_OWN_LICENSE or LICENSE_INCLUDED"
}

variable "ssh_public_keys" {
    type = set(string)
    description = "SSH keys for VM cluster"
}

variable "cpu_core_count" {
    type = string
    description = "Number of ECPUs assigned in total to all VMs in the cluster"
}

variable "memory_size_gb" {
  type = string
  description = "amount of memory assigned in total to all VMs in the cluster"
}

variable "db_node_storage_size_gb" {
    type = string
    description = "amount of local storage assigned in total to all VMs in the cluster"
}

variable "gi_version" {
  type = string
  description = "The GI version of the Exadata VM Cluster."
  default = "Exadata.X11M"
}

variable "hostname_prefix" {
  type = string
  description = "The hostname prefix of the Exadata VM Cluster."
}

variable "deletion_protection" {
  type = string
  description = "when set to true resources will be protected from accidental deletion"
  default = "true"
}