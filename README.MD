<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.15 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.89.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.89.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_secret_manager_secret.registry_sql_client_cert](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_secret_manager_secret) | resource |
| [google-beta_google_secret_manager_secret.registry_sql_user_password](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_secret_manager_secret) | resource |
| [google-beta_google_secret_manager_secret_version.registry_sql_client_cert](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_secret_manager_secret_version) | resource |
| [google-beta_google_secret_manager_secret_version.secret-version-basic](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_secret_manager_secret_version) | resource |
| [google_sql_database.cloudsql_database](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database_instance.cloudsql_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_ssl_cert.client_cert](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_ssl_cert) | resource |
| [google_sql_user.cloudsql_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [random_password.cloudsql_user_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_cidrs"></a> [authorized\_cidrs](#input\_authorized\_cidrs) | Authorized networks CIDRs to connect to Cloud SQL instance. | `map(string)` | `{}` | no |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | The backup\_configuration subblock for the database setings | <pre>list(object({<br>    enabled          = bool<br>    start_time       = string<br>    location         = string<br>    retained_backups = number<br>  }))</pre> | `[]` | no |
| <a name="input_cert_common_name"></a> [cert\_common\_name](#input\_cert\_common\_name) | Certificate Common Name. | `string` | n/a | yes |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | Database type and version. Supported values = {MYSQL\_5\_6, MYSQL\_5\_7, MYSQL\_8\_0, POSTGRES\_9\_6,POSTGRES\_10, POSTGRES\_11, POSTGRES\_12, POSTGRES\_13, ...}. See {Instance settings documentation} | `string` | n/a | yes |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Full name of the SQL database. | `string` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If set to true, you protect an instance from being deleted. | `bool` | `true` | no |
| <a name="input_disk_autoresize"></a> [disk\_autoresize](#input\_disk\_autoresize) | Whether if the disk can grow when more space is needed. If disk\_autoresize=true do not set disk\_size as terraform apply would try to set the disk\_size | `bool` | `true` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Type of disk used on the CloudSQL instance VM | `string` | `"PD_SSD"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Full name of the SQL instance. | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window to update/patch the VM. It can be rebooted during this maintenance window | <pre>list(object({<br>    day          = number<br>    hour         = number<br>    update_track = string<br>  }))</pre> | `[]` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | n/a | `any` | `null` | no |
| <a name="input_network"></a> [network](#input\_network) | Self link of the VPC network | `string` | n/a | yes |
| <a name="input_public_ip"></a> [public\_ip](#input\_public\_ip) | assign a public IP to this CloudSQL instance. Attention: you need Security approval to give a public IP to your CloudSQL instance. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to host the resources in. | `string` | `"europe-west1"` | no |
| <a name="input_require_ssl"></a> [require\_ssl](#input\_require\_ssl) | If require SSL, the connection port will be 3307, otherwise 3306. | `bool` | `true` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | CloudSQL instance machine type (service tier). See {Instance settings documentation} | `string` | n/a | yes |
| <a name="input_user_host"></a> [user\_host](#input\_user\_host) | The host the user can connect from. This is only supported for MySQL instances. Don't set this field for PostgreSQL instances. Can be an IP address, or % to allow any host. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | User name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | Cloud SQL connection name |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | Cloud SQL Database name |
| <a name="output_instance_connection_name"></a> [instance\_connection\_name](#output\_instance\_connection\_name) | The connection name of the instance to be used in connection strings. For example, when connecting with Cloud SQL Proxy. |
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | The IPv4 address assigned to the database instance. |
| <a name="output_instance_ip_address_type"></a> [instance\_ip\_address\_type](#output\_instance\_ip\_address\_type) | The type of IP address assigned to this instance. { PRIMARY \| OUTGOING \| PRIVATE }. This module handles with PRIVATE only |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | Cloud SQL Database instance name |
| <a name="output_secret_manager_cloudsql_client_cert_secret_id"></a> [secret\_manager\_cloudsql\_client\_cert\_secret\_id](#output\_secret\_manager\_cloudsql\_client\_cert\_secret\_id) | Secret manager id path where the CloudSQL client certificate secret is stored |
| <a name="output_secret_manager_cloudsql_user_secret_id"></a> [secret\_manager\_cloudsql\_user\_secret\_id](#output\_secret\_manager\_cloudsql\_user\_secret\_id) | Secret manager id where the CloudSQL user name/password secret is stored |
<!-- END_TF_DOCS -->