### Created by andycolvin@google.com
## Works in my tests, you break it, you buy it

data "google_compute_network" "vpc-network" {
  name     = var.network_name
  project = var.vpc_project
}

resource "google_oracle_database_odb_network" "odb-network"{
  odb_network_id  = var.odb_network_id
  location        = var.location
  project         = var.vpc_project
  network         = data.google_compute_network.vpc-network.id
  gcp_oracle_zone = var.gcp_oracle_zone
  labels = {
    terraform_created = "true"
  }
  deletion_protection = var.deletion_protection
}