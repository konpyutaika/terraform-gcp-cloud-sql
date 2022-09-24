terraform {
  required_version = ">=0.15"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.89.0"
    }
    # For CloudSQL
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = ">= 2.17.0"
    }
  }
}
