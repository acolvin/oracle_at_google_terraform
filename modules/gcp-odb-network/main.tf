### Created by andycolvin@google.com
## Works in my tests, you break it, you buy it

data "google_compute_network" "this" {
  name     = var.network_name
  project = var.vpc_project
}

resource "google_oracle_database_odb_network" "this"{
  odb_network_id  = var.odb_network_id
  location        = var.location
  project         = var.vpc_project
  network         = data.google_compute_network.this.id
  gcp_oracle_zone = var.gcp_oracle_zone
  labels = {
    terraform_created = "true"
  }
  deletion_protection = var.deletion_protection
}

resource "google_oracle_database_odb_subnet" "client_subnet"{
  depends_on = [ google_oracle_database_odb_network.this ]

  odb_subnet_id = "${var.odb_network_id}-c1"
  location      = var.location
  project       = var.vpc_project
  odbnetwork    = var.odb_network_id
  cidr_range    = var.client_cidr_range
  purpose       = "CLIENT_SUBNET"
  labels = {
    terraform_created = "true"
  }
  deletion_protection = var.deletion_protection
}

resource "google_oracle_database_odb_subnet" "backup_subnet"{
  depends_on = [ google_oracle_database_odb_subnet.client_subnet ]

  odb_subnet_id = "${var.odb_network_id}-b1"
  location      = var.location
  project       = var.vpc_project
  odbnetwork    = var.odb_network_id
  cidr_range    = var.backup_cidr_range
  purpose       = "BACKUP_SUBNET"
  labels = {
    terraform_created = "true"
  }
  deletion_protection = var.deletion_protection
}
