# gcp-adb

The `gcp-adb` module creates an Autonomous AI Database within Oracle Database@Google Cloud. The module expects an existing ODB network and client subnet to be provided already. A [Terraform module](modules/gcp-odb-network) to create ODB networks and ODB subnets is also available in this repository.

This module expects that the client ODB Subnet used follows the naming convention in the [gcp-odb-network](modules/gcp-odb-network) module, where the client subnet is named `{odb-network}-c1`.

## Example Usage - Standalone VPC
The code block below will create a new Autonomous AI Database in a [standalone VPC](https://docs.cloud.google.com/oracle/database/docs/setup-oracle-database-environment#odb-standalone-vpc-deployment) setup with the following attributes:

| Name | Description |
| --- | --- |
| Region | us-west3 |
| ADB Project | my-adb-project |
| ADB ID | myadb1 |
| Admin Password | your-password |
| ODB Network | my-odbnetwork |
| ECPU Count | 2 |
| Storage Size | 20GB |
| Database Version | 23ai |
| Workload Type | Transaction Processing |
| Database Edition | Enterprise Edition |
| License Type | Bring your own license |
| Automatic Backup Retention | 60 Days |
| Compute Auto-Scaling | Off |
| Storage Auto-Ccaling | Off |

```terraform
module "adb" {
  source = "../modules/gcp-adb"

  location               = "us-west3"
  adb_project            = "my-adb-project"
  autonomous_database_id = "myadb1"
  adb_admin_pw           = "your-password"
  vpc_project            = "my-adb-project"
  odb_network_id         = "my-odbnetwork"
  ecpu_count             = "2"
  data_storage_size_gb   = "20"
  db_version             = "23ai"
  workload_type          = "OLTP"
  db_edition             = "ENTERPRISE_EDITION"
  license_type           = "BRING_YOUR_OWN_LICENSE"
}
```

## Example Usage - Shared VPC
The code block below will create a new Autonomous AI Database in a [shared VPC](https://docs.cloud.google.com/oracle/database/docs/setup-oracle-database-environment#odb-shared-vpc-deployment) setup with the following attributes:

| Name | Description |
| --- | --- |
| Region | us-west3 |
| ADB Project | my-adb-project |
| ADB ID | myadb1 |
| Admin Password | your-password |
| VPC Host Project | my-network-host-project |
| ODB Network | my-odbnetwork |
| ECPU Count | 2 |
| Storage Size | 20GB |
| Database Version | 23ai |
| Workload Type | Transaction Processing |
| Database Edition | Enterprise Edition |
| License Type | Bring your own license |
| Automatic Backup Retention | 60 Days |
| Compute Auto-Scaling | Off |
| Storage Auto-Ccaling | Off |

```terraform
module "adb" {
  source = "../modules/gcp-adb"

  location               = "us-west3"
  adb_project            = "my-adb-project"
  autonomous_database_id = "myadb1"
  adb_admin_pw           = "your-password"
  vpc_project            = "my-network-host-project"
  odb_network_id         = "my-odbnetwork"
  ecpu_count             = "2"
  data_storage_size_gb   = "20"
  db_version             = "23ai"
  workload_type          = "OLTP"
  db_edition             = "ENTERPRISE_EDITION"
  license_type           = "BRING_YOUR_OWN_LICENSE"
}
```

## Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `autonomous_database_id` | The name of the autonomous database. | `string` | `null` | yes |
| `location` | GCP region where services are hosted. | `string` | `null` | yes |
| `adb_project` | The ID of the project in which the ADB belongs. | `string` | `null` | yes |
| `adb_admin_pw` | The admin password of your Autonomous Database. | `string` | `null` | yes |
| `vpc_project` | The ID of the project in which the ODB Network belongs. | `string` | `null` | yes |
| `odb_network_id` | The name of the ODB Network. | `string` | n/a | yes, if using private endpoint |
| `ecpu_count` | The number of ECPUs available to my instance. | `string` | `"2"` | yes |
| `data_storage_size_gb` | How much storage is available to the database. Used with OLTP, AJD, and APEX workload types. | `string` | `null` | yes, if workload type is set to `OLTP`, `AJD`, or `APEX` |
| `data_storage_size_tb` | How much storage is available to the database. Used with DW workload type | `string` | `null` | yes, if workload type is set to `DW` |
| `db_version` | Database version - either 19c or 23ai. | `string` | `"19c"` | no |
| `workload_type` | The workload type of the cluster, either OLTP, DW, AJD, APEX. | `string` | `"OLTP"` | yes |
| `db_edition` | Database edition. Can be set to `ENTERPRISE_EDITION` or `STANDARD_EDITION` | `string` | `"ENTERPRISE_EDITION"` | Required if license type is set to `BRING_YOUR_OWN_LICENSE` |
| `license_type` | Whether you are using BYOL or buying a license-included SKU. | `string` | `"LICENSE_INCLUDED"` | yes |
| `backup_retention_period_days` | Number of days that automatic backups should be stored | `string` | `"60"` | no |
| `is_auto_scaling_enabled` | Enables [auto-scaling for CPU resources](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adbsb/autonomous-auto-scale.html). | `string` | `"false"` | no |
| `is_storage_auto_scaling_enabled` | Enables [auto-scaling for storage resources](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adbsb/autonomous-auto-scale.html) | `string` | `"false"` | no |
| `deletion_protection` | When set to true resources will be protected from accidental deletion. | `string` | `"true"` | no |

## TODO
The following items are expected to be added at a later date
 - Creation of additional outputs
 - Cofngiuration of public-facing ADB instances
 - Additional flexibility for ODB subnet naming
 - Cross-zone disaster recovery (when available)
 - Customer-managed encryption keys (when available)
