
output "instance_name" {
  value       = google_sql_database_instance.cloudsql_instance.name
  description = "Cloud SQL Database instance name"
}

output "instance_connection_name" {
  value       = google_sql_database_instance.cloudsql_instance.connection_name
  description = "The connection name of the instance to be used in connection strings. For example, when connecting with Cloud SQL Proxy."
}

output "instance_ip_address" {
  value       = google_sql_database_instance.cloudsql_instance.ip_address
  description = "The IPv4 address assigned to the database instance."
}

output "instance_ip_address_type" {
  value       = google_sql_database_instance.cloudsql_instance.ip_address[0].type
  description = "The type of IP address assigned to this instance. { PRIMARY | OUTGOING | PRIVATE }. This module handles with PRIVATE only"
}

output "database_name" {
  value       = google_sql_database.cloudsql_database.name
  description = "Cloud SQL Database name"
}

output "connection_name" {
  value       = google_sql_database_instance.cloudsql_instance.connection_name
  description = "Cloud SQL connection name"
}

output "secret_manager_cloudsql_user_secret_id" {
  value       = google_secret_manager_secret.registry_sql_user_password.secret_id
  description = "Secret manager id where the CloudSQL user name/password secret is stored"
}

output "secret_manager_cloudsql_client_cert_secret_id" {
  value       = google_secret_manager_secret.registry_sql_client_cert.secret_id
  description = "Secret manager id path where the CloudSQL client certificate secret is stored"
}