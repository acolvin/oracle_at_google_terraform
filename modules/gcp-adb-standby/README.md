# gcp-adb

The `gcp-adb-standby` module creates an Autonomous AI Database standby peer database within Oracle Database@Google Cloud. The module expects an existing primary ADB instance in one region, and ODB network and client subnet in the standby region. A [Terraform module](modules/gcp-odb-network) to create ODB networks and ODB subnets is also available in this repository.

This module expects that the client ODB Subnet used follows the naming convention in the [gcp-odb-network](modules/gcp-odb-network) module, where the client subnet is named `{odb-network}-c1`.

## Example Usage - Standalone VPC
The code block below will create a new standby Autonomous AI Database in a [standalone VPC](https://docs.cloud.google.com/oracle/database/docs/setup-oracle-database-environment#odb-standalone-vpc-deployment) setup with the following attributes:

| Name | Description |
| --- | --- |
| Standby Database Region | us-west3 |
| ADB Project | my-adb-project |
| Standby Database Display Name | peerdb1_slc |
| Standby Database ID | peerdb1 |
| Standby Database ODB Network | my-odbnetwork |
| Primary Database Region | us-east4 |
| Primary Database ID | myadb1 |
| Cross-Region Backup Replication | true |

```terraform
module "peer-adb" {
  source = "../modules/gcp-adb-standby"

  peer_autonomous_database_id           = "peerdb1"
  peer_adb_location                     = "us-west3"
  adb_project                           = "my-adb-project"
  peer_autonomous_database_display_name = "peerdb1_slc"
  vpc_project                           = "my-adb-project"
  odb_network_id                        = "my-odbnetwork"
  odb_subnet_id                         = "myodbnetwork1-c1"
  source_adb_id                         = "projects/my-adb-project/locations/us-east4/autonomousDatabases/myadb1"
  backup_replication_enabled            = true
  deletion_protection                   = true
}
```

## Example Usage - Shared VPC
The code block below will create a new Autonomous AI Database in a [shared VPC](https://docs.cloud.google.com/oracle/database/docs/setup-oracle-database-environment#odb-shared-vpc-deployment) setup with the following attributes:

| Name | Description |
| --- | --- |
| Standby Database Region | us-west3 |
| ADB Project | my-adb-project |
| Standby Database Display Name | peerdb1_slc |
| Standby Database ID | peerdb1 |
| Shared VPC Host Project | my-network-host-project |
| Standby Database ODB Network | my-odbnetwork |
| Primary Database Region | us-east4 |
| Primary Database ID | myadb1 |
| Cross-Region Backup Replication | true |

```terraform
module "peer-adb" {
  source = "../modules/gcp-adb-standby"

  peer_autonomous_database_id           = "peerdb1"
  peer_adb_location                     = "us-west3"
  adb_project                           = "my-adb-project"
  peer_autonomous_database_display_name = "peerdb1_slc"
  vpc_project                           = "my-network-host-project"
  odb_network_id                        = "myodbnetwork1"
  odb_subnet_id                         = "myodbnetwork1-c1"
  source_adb_id                         = "projects/my-adb-project/locations/us-east4/autonomousDatabases/myadb1"
  backup_replication_enabled            = true
  deletion_protection                   = true
}
```

## Inputs

| Name | Description |
| --- | --- |
| peer_autonomous_database_id | Name of the peer database |
| peer_adb_location | The GCP region where you want to deploy the peer database |
| adb_project | The project where your ADB instance will be deployed |
| peer_autonomous_database_display_name | Display name of the peer database |
| vpc_project | The project where your ADB instance will be deployed |
| odb_network_id | ID of the ODB network where the peer database will be deployed |
| odb_subnet_id | ID of the ODB subnet where the peer database will be deployed |
| source_adb_id | Fully-qualified ID of the primary database |
| backup_replication_enabled | Set to `true` if you want to replicate backups to the peer region |
| deletion_protection | Set to `true` to prevent acciidental resource deletion |

## TODO
The following items are expected to be added at a later date
 - Creation of additional outputs
 - Cofngiuration of public-facing ADB instances
 - Additional flexibility for ODB subnet naming
 - Cross-zone disaster recovery (when available)
 - Customer-managed encryption keys (when available)
