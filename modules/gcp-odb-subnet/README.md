# gcp-odb-subnet

This module creates ODB Subnets within an existing ODB Network. 

## Usage
The code below can be used to create an ODB client Subnet in the `odbnetwork1` ODB Network in the `us-west3` region. The client subnet is configured to use the `10.15.23.0/24` CIDR range.

The module uses a `depends_on` clause to confirm that it is only created after the corresponding [ODB Network](../gcp-odb-network) has been created.

```terraform
module "client-subnet" {
  source = "../modules/gcp-odb-subnet"
  depends_on = [ module.odb-network ]

  # Required
  odb_subnet_id          = "odbnetwork1-client1"
  location               = "us-west3"
  vpc_project            = "my-host-project"
  odb_network_id         = "odbnetwork1"
  subnet_cidr_range      = "10.15.23.0/24"
  subnet_purpose         = "CLIENT_SUBNET"
  deletion_protection    = "true"
}
```

## Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `odb_subnet_id` | The name of the ODB Subnet. | `string` | null | yes |
| `location` | GCP region where services are hosted. | `string` | null | yes |
| `vpc_project` | The ID of the project in which the resource belongs. | `string` | null | yes |
| `odb_network_id` | The name of the ODB Network. | `string` | null | yes |
| `subnet_cidr_range` | The CIDR range used for the  ODB Subnet. | `string` | null | yes |
| `subnet_purpose` | The type of subnet, either `CLIENT_SUBNET` or `BACKUP_SUBNET` | `string` | `"CLIENT_SUBNET"` | no |
| `deletion_protection` | When set to true resources will be protected from accidental deletion. | `string` | `"true"` | no |