### gcp-adb

This module deploys a Oracle Autonomous AI Database (ADB) instance on Oracle Database@Google Cloud.

#### Usage

```terraform
module "adb" {
  source = "../../modules/gcp-adb"

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

#### Variables

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `autonomous_database_id` | The name of the autonomous database. | `string` | `null` | yes |
| `adb_admin_pw` | The admin password of your Autonomous Database. | `string` | `null` | yes |
| `location` | GCP region where services are hosted. | `string` | `null` | yes |
| `adb_project` | The ID of the project in which the ADB belongs. | `string` | `null` | yes |
| `vpc_project` | The ID of the project in which the ODB Network belongs. | `string` | `null` | no |
| `odb_network_id` | The name of the ODB Network. | `string` | n/a | yes, if using private endpoint |
| `ecpu_count` | The number of ECPUs available to my instance. | `string` | `"2"` | no |
| `data_storage_size_gb` | How much storage is available to the database. Used with OLTP, AJD, and APEX workload types. | `string` | `null` | no |
| `data_storage_size_tb` | How much storage is available to the database. Used with DW workload type | `string` | `null` | no |
| `db_version` | Database version - either 19c or 23ai. | `string` | `"19c"` | no |
| `workload_type` | The workload type of the cluster, either OLTP, DW, AJD, APEX. | `string` | `"OLTP"` | no |
| `db_edition` | Database edition. Can be set to `ENTERPRISE_EDITION` or `STANDARD_EDITION` | `string` | `"ENTERPRISE_EDITION"` | Required if license type is set to `BRING_YOUR_OWN_LICENSE` |
| `license_type` | Whether you are using BYOL or buying a license-included SKU. | `string` | `"LICENSE_INCLUDED"` | no |
| `backup_retention_period_days` | Number of days that automatic backups should be stored | `string` | `"60"` | no |
| `is_auto_scaling_enabled` | Enables [auto-scaling for CPU resources](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adbsb/autonomous-auto-scale.html). | `string` | `"false"` | no |
| `is_storage_auto_scaling_enabled` | Enables [auto-scaling for storage resources](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adbsb/autonomous-auto-scale.html) | `string` | `"false"` | no |
| `deletion_protection` | When set to true resources will be protected from accidental deletion. | `string` | `"true"` | no |
