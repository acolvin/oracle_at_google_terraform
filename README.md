# Example Terraform Modules for Deploying Oracle Database@Google Cloud

This repository contains example Terraform code for deploying Oracle Database@Google Cloud. The modules are designed to be reusable and configurable, allowing you to easily create and manage your Oracle database environments.

Each example creates an ODB Network, client and backup subnets, and either an Autonomous Serverless instance or Exadata infrastructure and VM Cluster.

Update the local variables within `examples/exa-plus-shared-vpc/main.tf` or `examples/adb-plus-shared-vpc/main.tf`

## Modules

This repository includes the following modules:

*   **gcp-odb-network**: Creates the necessary networking resources for Oracle databases, including an ODB Network and ODB Subnets for client and backup traffic.
*   **gcp-adb**: Deploys a Google Cloud Autonomous Database (ADB) instance.
*   **gcp-exadata-infra**: Deploys the underlying Exadata infrastructure for Exadata database deployments.
*   **gcp-exadata-vmcluster**: Deploys an Exadata VM cluster on top of the Exadata infrastructure.

## Getting Started

To use these modules, you will need to have Terraform installed and configured for your Google Cloud environment. You can then reference the modules in your own Terraform code.

### Prerequisites

*   [Terraform](https://www.terraform.io/downloads.html)
*   [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
*   A Google Cloud project with the required APIs enabled.

### Examples

The `examples` directory contains example deployments that demonstrate how to use the modules.

*   **adb-plus-shared-vpc**: Deploys an Autonomous Database instance in a shared VPC environment.
*   **exa-plus-shared-vpc**: Deploys an Exadata infrastructure and VM cluster in a shared VPC environment.

To use the examples, navigate to the example directory and run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Module Details

### gcp-odb-network

This module creates the networking resources required for Oracle databases in Google Cloud.

#### Usage

```terraform
module "odb-network" {
  source = "../../modules/gcp-odb-network"

  location          = "us-west3"
  vpc_project       = "my-network-host-project"
  network_name      = "default"
  gcp_oracle_zone   = "us-west3-a-r1"
  odb_network_id    = "tf-slc-odbnetwork"
  client_cidr_range = "172.16.119.0/25"
  backup_cidr_range = "172.16.119.128/25"
}
```

#### Variables

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `network_name` | The name of the VPC network used by the ODB Network. | `string` | n/a | yes |
| `vpc_project` | The ID of the project in which the resource belongs. | `string` | `""` | no |
| `odb_network_id` | The name of the ODB Network. | `string` | n/a | yes |
| `location` | GCP region where services are hosted. | `string` | n/a | yes |
| `client_cidr_range` | The CIDR range used for the client ODB Subnet. | `string` | n/a | yes |
| `backup_cidr_range` | The CIDR range used for the backup ODB Subnet. | `string` | n/a | yes |
| `gcp_oracle_zone` | The zone where the ODB Network will reside. | `string` | `"Any"` | no |
| `deletion_protection` | When set to true resources will be protected from accidental deletion. | `string` | `"true"` | no |

### gcp-adb

This module deploys a Google Cloud Autonomous Database (ADB) instance.

#### Usage

```terraform
module "adb" {
  source = "../../modules/gcp-adb"

  location               = "us-west3"
  adb_project            = "my-adb-project"
  autonomous_database_id = "myadb1"
  adb_admin_pw           = "your-password"
  vpc_project            = "my-network-host-project"
  odb_network_id         = "tf-slc-odbnetwork"
  ecpu_count             = "2"
  data_storage_size_gb   = "20"
  db_version             = "23ai"
  workload_type          = "OLTP"
  db_edition             = "ENTERPRISE_EDITION"
  license_type           = "LICENSE_INCLUDED"
}
```

#### Variables

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `autonomous_database_id` | The name of the autonomous database. | `string` | n/a | yes |
| `adb_admin_pw` | The admin password of your Autonomous Database. | `string` | n/a | yes |
| `location` | GCP region where services are hosted. | `string` | n/a | yes |
| `adb_project` | The ID of the project in which the ADB belongs. | `string` | `""` | no |
| `vpc_project` | The ID of the project in which the ODB Network belongs. | `string` | `""` | no |
| `odb_network_id` | The name of the ODB Network. | `string` | n/a | yes |
| `ecpu_count` | The number of ECPUs available to my instance. | `string` | `"2"` | no |
| `data_storage_size_gb` | How much storage is available to the database. | `string` | `"20"` | no |
| `db_version` | Database version - either 19c or 23ai. | `string` | `"19c"` | no |
| `workload_type` | The workload type of the cluster, either OLTP, DW, AJD, APEX. | `string` | `"OLTP"` | no |
| `db_edition` | Database edition. | `string` | `"ENTERPRISE_EDITION"` | no |
| `license_type` | Whether you are using BYOL or buying a license-included SKU. | `string` | `"LICENSE_INCLUDED"` | no |
| `deletion_protection` | When set to true resources will be protected from accidental deletion. | `string` | `"true"` | no |

### gcp-exadata-infra

This module deploys the underlying Exadata infrastructure for Exadata database deployments.

#### Usage

```terraform
module "exadata-infra" {
  source = "../../modules/gcp-exadata-infra"

  location                        = "us-west3"
  exa_infra_project               = "my-exadata-infra-project"
  gcp_oracle_zone                 = "us-west3-a-r1"
  cloud_exadata_infrastructure_id = "ofake-tf-slc1"
  shape                           = "Exadata.X9M"
  compute_count                   = "2"
  storage_count                   = "3"
}
```

#### Variables

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `location` | GCP region where services are hosted. | `string` | n/a | yes |
| `exa_infra_project` | The ID of the project in which the Exadata infrastructure belongs. | `string` | `""` | no |
| `cloud_exadata_infrastructure_id` | The name of the Exadata infrastructure. | `string` | n/a | yes |
| `gcp_oracle_zone` | The zone where the Exadata infrastructure will reside. | `string` | n/a | yes |
| `shape` | The shape for the Exadata infrastructure. | `string` | `"Exadata.X11M"` | no |
| `compute_count` | The number of compute servers used by the infrastructure. | `string` | `"2"` | no |
| `storage_count` | The number of storage servers used by the infrastructure. | `string` | `"3"` | no |
| `deletion_protection` | When set to true resources will be protected from accidental deletion. | `string` | `"true"` | no |

### gcp-exadata-vmcluster

This module deploys an Exadata VM cluster on top of the Exadata infrastructure.

#### Usage

```terraform
module "vmcluster-1" {
  source = "../../modules/gcp-exadata-vmcluster"

  location                        = "us-west3"
  exa_infra_project               = "my-exadata-infra-project"
  exa_vm_project                  = "my-exadata-vm-project"
  vpc_project                     = "my-network-host-project"
  odb_network_id                  = "tf-slc-odbnetwork"
  cloud_vm_cluster_id             = "ofake-vmc1"
  cloud_exadata_infrastructure_id = "ofake-tf-slc1"
  gi_version                      = "23.0.0.0"
  license_type                    = "BRING_YOUR_OWN_LICENSE"
  hostname_prefix                 = "slc-vmc1"
  cpu_core_count                  = "32"
  memory_size_gb                  = "60"
  db_node_storage_size_gb         = "120"
  ssh_public_keys                 = ["ssh-rsa ..."]
}
```

#### Variables

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `location` | GCP region where services are hosted. | `string` | n/a | yes |
| `exa_infra_project` | The ID of the project in which the Exadata infrastructure belongs. | `string` | `""` | no |
| `cloud_exadata_infrastructure_id` | The name of the Exadata infrastructure. | `string` | n/a | yes |
| `cloud_vm_cluster_id` | The name of the Exadata VM Cluster. | `string` | n/a | yes |
| `exa_vm_project` | The ID of the project in which the Exadata VM cluster belongs. | `string` | `""` | no |
| `vpc_project` | Project ID for the shared VPC. | `string` | n/a | yes |
| `odb_network_id` | The name of the ODB Network. | `string` | n/a | yes |
| `license_type` | Either BRING_YOUR_OWN_LICENSE or LICENSE_INCLUDED. | `string` | n/a | yes |
| `ssh_public_keys` | SSH keys for VM cluster. | `set(string)` | n/a | yes |
| `cpu_core_count` | Number of ECPUs assigned in total to all VMs in the cluster. | `string` | n/a | yes |
| `memory_size_gb` | Amount of memory assigned in total to all VMs in the cluster. | `string` | n/a | yes |
| `db_node_storage_size_gb` | Amount of local storage assigned in total to all VMs in the cluster. | `string` | n/a | yes |
| `gi_version` | The GI version of the Exadata VM Cluster. | `string` | `"Exadata.X11M"` | no |
| `hostname_prefix` | The hostname prefix of the Exadata VM Cluster. | `string` | n/a | yes |
| `deletion_protection` | When set to true resources will be protected from accidental deletion. | `string` | `"true"` | no |
