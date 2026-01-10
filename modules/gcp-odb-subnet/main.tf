resource "google_oracle_database_odb_subnet" "odb_subnet"{
  odb_subnet_id = var.odb_subnet_id
  location      = var.location
  project       = var.vpc_project
  odbnetwork    = var.odb_network_id
  cidr_range    = var.subnet_cidr_range
  purpose       = var.subnet_purpose
  labels = {
    terraform_created = "true"
  }
  deletion_protection = var.deletion_protection
}