# gcp-odb-network

This module creates the networking resources required for Oracle databases in Google Cloud. It will create an ODB Network and two ODB Subnets: one client subnet and one backup subnet. The subnets are named using ID of the ODB Network, and append `-c1` and `-b1` for the client and backup subnets, respectively.

ODB Networks that will be used in a [Shared VPC](https://docs.cloud.google.com/oracle/database/docs/setup-oracle-database-environment#odb-shared-vpc-deployment) environment must be created in the host project.

## Usage
The code below can be used to create an ODB Network and two ODB Subnets in the us-west3 region. In this example, the client and backup subnets will be named `tf-slc-odbnetwork-c1` and `tf-slc-odbnetwork-b1`.

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

## Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `network_name` | The name of the VPC network used by the ODB Network. | `string` | n/a | yes |
| `vpc_project` | The ID of the project in which the resource belongs. | `string` | `""` | yes |
| `odb_network_id` | The name of the ODB Network. | `string` | n/a | yes |
| `location` | GCP region where services are hosted. | `string` | n/a | yes |
| `client_cidr_range` | The CIDR range used for the client ODB Subnet. | `string` | n/a | yes |
| `backup_cidr_range` | The CIDR range used for the backup ODB Subnet. | `string` | n/a | yes |
| `gcp_oracle_zone` | The zone where the ODB Network will reside. | `string` | `"Any"` | no |
| `deletion_protection` | When set to true resources will be protected from accidental deletion. | `string` | `"true"` | no |