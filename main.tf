resource "google_sql_database_instance" "cloudsql_instance" {
  name             = var.instance_name
  region           = var.region
  database_version = var.database_version

  # settings section is optional unless clone is not set. We do not implement clone but insted we create a new instance. 
  # Thus, settings becomes mandatory in this implementation
  # Some of the settigs set are the same as terraform default values but explicitly set
  settings {
    tier            = var.tier
    disk_autoresize = var.disk_autoresize
    disk_type       = var.disk_type

    # (backup_configuration is optional)
    dynamic "backup_configuration" {
      for_each = var.backup_configuration

      content {
        enabled    = backup_configuration.value.enabled
        start_time = backup_configuration.value.start_time
        location   = backup_configuration.value.location
        backup_retention_settings {
          retained_backups = backup_configuration.value.retained_backups
          # retention_unit = "COUNT"
        }
      }
    }

    ip_configuration {
      # should this cloud sql get assigned a public ip ?
      ipv4_enabled = var.public_ip
      # VPC network from which cloudsql instance is accessible for private IP.
      private_network = var.network
      require_ssl     = var.require_ssl

      # Authorized networks can be configured if:
      # - client application is connecting directly to a Cloud SQL instance on its public IP address
      # - client application is connecting directly to a Cloud SQL instance on its private IP address, 
      #   and your client's IP address is a non-RFC 1918 address
      # ref: # https://cloud.google.com/sql/docs/mysql/authorize-networks
      #
      # Limitations: addresses that cannot be added as authorized networks
      # RFC1918 private addresses (THEY ARE AUTOMATICALLY INCLUDED), 
      # RFC1122 Loopback,  172.17/16 docker bridge nw,
      # RFC3330 null network, RFC3927/2373 link-local, RFC3330/3849 documentation nw,
      # RFC3330 multicast networks, class-E address space (RFC1112)
      #   
      # (authorized_networks is optional)
      dynamic "authorized_networks" {
        for_each = var.authorized_cidrs
        iterator = ntw

        content {
          name  = ntw.key
          value = ntw.value
        }
      }
    }

    # maintenance window (for updates and needed restarts) - Time: UTC, Day: 1-7 (1==Monday,...)
    # By default it does maintenance window any time, any day.
    # (maintenance_window is optional)
    dynamic "maintenance_window" {
      for_each = var.maintenance_window
      iterator = window
      content {
        day          = window.value.day
        hour         = window.value.hour
        update_track = window.value.update_track
      }
    }

  }

  deletion_protection = var.deletion_protection
}

### User 

# Password - provide a strong password unless password already provided via variable

# Provide a "Strong" password
# https://dev.mysql.com/doc/refman/8.0/en/validate-password.html
# Note that Password Policy STRONG => lenght>8, 1 numeric + 1 lowercase + 1 uppercase + 1 special, substring of len>=4 are not dictionary words
resource "random_password" "cloudsql_user_password" {
  length           = 20
  special          = true
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "_%@$#"
}

resource "google_sql_user" "cloudsql_user" {
  name     = var.user_name
  instance = google_sql_database_instance.cloudsql_instance.name
  password = sensitive(random_password.cloudsql_user_password.result)
  host     = var.user_host
}

### Database
resource "google_sql_database" "cloudsql_database" {
  name     = var.db_name
  instance = google_sql_database_instance.cloudsql_instance.name
}

### Certificate
resource "google_sql_ssl_cert" "client_cert" {
  common_name = var.cert_common_name
  instance    = google_sql_database_instance.cloudsql_instance.name
}

### TODO: Secret manager
resource "google_secret_manager_secret" "registry_sql_user_password" {
  provider = google-beta
  secret_id = "${var.instance_name}_sql_user_password"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  provider = google-beta
  secret = google_secret_manager_secret.registry_sql_user_password.id

  secret_data = sensitive(
    jsonencode(
      {
        "cloudsql_instance_name" = google_sql_user.cloudsql_user.instance
        "cloudsql_user_name"     = google_sql_user.cloudsql_user.name
        "cloudsql_user_password" = random_password.cloudsql_user_password.result
      }
    )
  )
}

resource "google_secret_manager_secret" "registry_sql_client_cert" {
  provider = google-beta
  secret_id = "${var.instance_name}_sql_client_cert"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "registry_sql_client_cert" {
  provider = google-beta
  secret = google_secret_manager_secret.registry_sql_client_cert.id

  secret_data = sensitive(
    jsonencode(
      {
        "cert"           = base64encode(google_sql_ssl_cert.client_cert.cert)
        "private_key"    = base64encode(google_sql_ssl_cert.client_cert.private_key)
        "server_ca_cert" = base64encode(google_sql_ssl_cert.client_cert.server_ca_cert)
      }
    )
  )
}
