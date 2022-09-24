
###############################################################
# Default variables                                           #
###############################################################

##### GCP PROJECT
#
# variable "project_id" {
#   type        = string
#   description = "The project ID to host resources."
# }

variable "region" {
  type        = string
  description = "The region to host the resources in."
  default     = "europe-west1"
}

###### Cloud SQL

# Cloud SQL configuration
# {Instance settings documentation} [https://cloud.google.com/sql/docs/<mysq|postgres|sqlserver>/instance-settings]
# {Instance locations documentation} [https://cloud.google.com/sql/docs/<mysql|postgres|sqlserver>/locations]


variable "instance_name" {
  type        = string
  description = "Full name of the SQL instance."
}

variable "db_name" {
  type        = string
  description = "Full name of the SQL database."
}

variable "cert_common_name" {
  type        = string
  description = "Certificate Common Name."
}

variable "user_name" {
  type        = string
  description = "User name."
}

variable "user_host" {
  type        = string
  description = "The host the user can connect from. This is only supported for MySQL instances. Don't set this field for PostgreSQL instances. Can be an IP address, or % to allow any host. Changing this forces a new resource to be created."
  default     = null
}

### Other parameters

variable "deletion_protection" {
  type        = bool
  description = "If set to true, you protect an instance from being deleted."
  default     = true
}

# Settings 

variable "database_version" {
  type        = string
  description = "Database type and version. Supported values = {MYSQL_5_6, MYSQL_5_7, MYSQL_8_0, POSTGRES_9_6,POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13, ...}. See {Instance settings documentation}"
}

variable "tier" {
  type        = string
  description = "CloudSQL instance machine type (service tier). See {Instance settings documentation}"
}

variable "disk_autoresize" {
  type        = bool
  description = "Whether if the disk can grow when more space is needed. If disk_autoresize=true do not set disk_size as terraform apply would try to set the disk_size"
  default     = true
}

variable "disk_type" {
  type        = string
  description = "Type of disk used on the CloudSQL instance VM"
  default     = "PD_SSD"
}

# IP configuration 
# Note that we do not allow the usage of public_ip but instead ise a private_network to 
# reach the CloudSQL instance 

variable "public_ip" {
  type        = bool
  description = "assign a public IP to this CloudSQL instance. Attention: you need Security approval to give a public IP to your CloudSQL instance."
  default     = false
} 

variable "network" {
  type        = string
  description = "Self link of the VPC network"
}

variable "require_ssl" {
  type        = bool
  description = "If require SSL, the connection port will be 3307, otherwise 3306."
  default     = true
}

variable "authorized_cidrs" {
  type        = map(string)
  description = "Authorized networks CIDRs to connect to Cloud SQL instance."
  default     = {}
}

# Backup
variable "backup_configuration" {
  description = "The backup_configuration subblock for the database setings"
  type = list(object({
    enabled          = bool
    start_time       = string
    location         = string
    retained_backups = number
  }))
  default = []
}

# OS updates
variable "maintenance_window" {
  description = "Maintenance window to update/patch the VM. It can be rebooted during this maintenance window"
  type = list(object({
    day          = number
    hour         = number
    update_track = string
  }))
  default = []
}


###############################################################
# Custom variables                                            #
###############################################################

# Add here some custom / additional variables

variable "module_depends_on" {
  type    = any
  default = null
}