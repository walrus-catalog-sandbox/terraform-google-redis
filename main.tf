locals {
  project_name     = coalesce(try(var.context["project"]["name"], null), "default")
  project_id       = coalesce(try(var.context["project"]["id"], null), "default_id")
  environment_name = coalesce(try(var.context["environment"]["name"], null), "test")
  environment_id   = coalesce(try(var.context["environment"]["id"], null), "test_id")
  resource_name    = coalesce(try(var.context["resource"]["name"], null), "example")
  resource_id      = coalesce(try(var.context["resource"]["id"], null), "example_id")

  namespace = join("-", [local.project_name, local.environment_name])

  tags = {
    "Name" = local.resource_name

    "walrus.seal.io-catalog-name"     = "terraform-google-redis"
    "walrus.seal.io-project-id"       = local.project_id
    "walrus.seal.io-environment-id"   = local.environment_id
    "walrus.seal.io-resource-id"      = local.resource_id
    "walrus.seal.io-project-name"     = local.project_name
    "walrus.seal.io-environment-name" = local.environment_name
    "walrus.seal.io-resource-name"    = local.resource_name
  }

  architecture = coalesce(var.architecture, "standalone")
}

locals {
  version = lookup({
    "7.0" = "REDIS_7_0",
    "6.0" = "REDIS_6_X",
    "5.0" = "REDIS_5_0",
    "4.0" = "REDIS_4_0",
    "3.2" = "REDIS_3_2",
  }, var.engine_version, "REDIS_7_0")
}

# create network.
resource "google_compute_network" "default" {
  count = var.infrastructure.vpc_id == null ? 1 : 0

  name = local.fullname
}

resource "google_compute_global_address" "default" {
  count = var.infrastructure.vpc_id == null ? 1 : 0

  name          = local.fullname
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.default[0].id
}

# create private vpc connection.
resource "google_service_networking_connection" "default" {
  count = var.infrastructure.vpc_id == null ? 1 : 0

  network                 = google_compute_network.default[0].id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.default[0].name]
  deletion_policy         = "ABANDON"
}

#
# Random
#

# create the name with a random suffix.

resource "random_string" "name_suffix" {
  length  = 9
  special = false
  upper   = false
}

#
# Deployment
#

# create server.

locals {
  name     = join("-", [local.resource_name, random_string.name_suffix.result])
  fullname = format("walrus-%s", md5(join("-", [local.namespace, local.name])))

  replication_readonly_replicas = var.replication_readonly_replicas == 0 ? 1 : var.replication_readonly_replicas

  configs = { for c in(var.engine_parameters != null ? var.engine_parameters : []) : c.name => c.value }
}

resource "google_redis_instance" "primary" {
  name          = local.fullname
  redis_version = local.version
  auth_enabled  = true

  labels = {
    "walrus-seal-io-catalog-name"     = "terraform-google-redis"
    "walrus-seal-io-project-id"       = local.project_id
    "walrus-seal-io-environment-id"   = local.environment_id
    "walrus-seal-io-resource-id"      = local.resource_id
    "walrus-seal-io-project-name"     = local.project_name
    "walrus-seal-io-environment-name" = local.environment_name
    "walrus-seal-io-resource-name"    = local.resource_name
  }

  memory_size_gb = var.storage.size

  tier = var.resources.class

  authorized_network = var.infrastructure.vpc_id == null ? google_compute_network.default[0].id : var.infrastructure.vpc_id

  replica_count      = var.architecture == "replication" ? local.replication_readonly_replicas : 0
  read_replicas_mode = var.architecture == "replication" ? "READ_REPLICAS_ENABLED" : "READ_REPLICAS_DISABLED"

  customer_managed_key = try(var.infrastructure.kms_key_id, null)

  redis_configs = local.configs

  depends_on = [google_service_networking_connection.default]
}
