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

# create redis service.

module "this" {
  source = "../.."

  architecture = "replication"

  replication_readonly_replicas = 3
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
