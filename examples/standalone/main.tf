terraform {
  required_version = ">= 1.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 3.5.0"
    }
  }
}

provider "google" {
}

// create network.
resource "google_compute_network" "example" {
  name = "private-network"
}

resource "google_compute_firewall" "example" {
  name    = "private-network-firewall-policy"
  network = google_compute_network.example.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  depends_on = [google_compute_network.example]
}

resource "google_compute_global_address" "example" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.example.id
}

// create private vpc connection.
resource "google_service_networking_connection" "example" {
  network                 = google_compute_network.example.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.example.name]
  deletion_policy         = "ABANDON"
}

# create redis service.

module "this" {
  source = "../.."

  infrastructure = {
    vpc_id = google_compute_network.example.id
  }

  architecture = "standalone"

  depends_on = [google_service_networking_connection.example]
}

output "context" {
  description = "The input context, a map, which is used for orchestration."
  value       = module.this.context
}

output "refer" {
  value = nonsensitive(module.this.refer)
}

output "connection" {
  value = module.this.connection
}

output "connection_readonly" {
  value = module.this.connection_readonly
}

output "address" {
  value = module.this.address
}

output "address_readonly" {
  value = module.this.address_readonly
}

output "port" {
  value = module.this.port
}

output "password" {
  value = nonsensitive(module.this.password)
}
