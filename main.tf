terraform {

  backend "gcs" {
    bucket = "crizstian-terraform"
    prefix = "cristian-selatam-sql"
  }

  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

variable "gcp_project_id" {
  default = "sales-209522"
}
variable "gcp_region" {
  default = "us-central1"
}
variable "sql_instance_name" {}
variable "db_name" {}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  alias   = "gcp"
}

resource "google_sql_database_instance" "example" {
  name             = var.sql_instance_name
  database_version = "POSTGRES_15"
  region           = var.gcp_region

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "example" {
  name     = var.db_name
  instance = google_sql_database_instance.example.name
  project = var.gcp_project_id
}

output "connection_name" {
  value = google_sql_database_instance.example.connection_name
}
