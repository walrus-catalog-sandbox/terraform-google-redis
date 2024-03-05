#
# Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}

#
# Infrastructure Fields
#

variable "infrastructure" {
  description = <<-EOF
Specify the infrastructure information for deploying.

Examples:
```
infrastructure:
  vpc_id: string, optional                  # the ID of the VPC where the Redis service applies. It is a fully-qualified resource name, such as projects/{project_id}/global/networks/{network_id}.
```
EOF
  type = object({
    vpc_id = optional(string)
  })
  default = {}
}

#
# Deployment Fields
#

variable "architecture" {
  description = <<-EOF
Specify the deployment architecture, select from standalone or replication.
EOF
  type        = string
  default     = "standalone"
  validation {
    condition     = var.architecture == "" || contains(["standalone", "replication"], var.architecture)
    error_message = "Invalid architecture"
  }
}

variable "replication_readonly_replicas" {
  description = <<-EOF
Specify the number of read-only replicas under the replication deployment.
EOF
  type        = number
  default     = 1
  validation {
    condition     = var.replication_readonly_replicas == 0 || contains([1, 3, 5], var.replication_readonly_replicas)
    error_message = "Invalid number of read-only replicas"
  }
}

variable "engine_version" {
  description = <<-EOF
Specify the deployment engine version, select from 7.0, 6.0, 5.0, 4.0, 3.2.
EOF
  type        = string
  default     = "7.0"
  validation {
    condition     = var.engine_version == "" || contains(["7.0", "6.0", "5.0", "4.0", "3.2"], var.engine_version)
    error_message = "Invalid version"
  }
}

variable "engine_parameters" {
  description = <<-EOF
Specify the deployment parameters, see https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Instance.FIELDS.redis_configs
EOF
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "resources" {
  description = <<-EOF
Specify the computing resources.
Select from BASIC, STANDARD_HA.Choosing the computing resource is also related to the storage resource, please view the specification document for more information.

Examples:
```
resources:
  class: string, optional            # https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Tier
```
EOF
  type = object({
    class = optional(string, "STANDARD_HA")
  })
  default = {
    class = "STANDARD_HA"
  }
}

variable "storage" {
  description = <<-EOF
Specify the Redis memory storage size in gigabytes.
Examples:
```
storage:
  size: number, optional         # in gigabytes
```
EOF
  type = object({
    size = optional(number, 5)
  })
  default = {
    size = 5
  }
}
