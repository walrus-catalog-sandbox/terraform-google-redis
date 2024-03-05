# Google Redis Server

Terrafom module to deploy a Redis Server on Google Cloud.

- [x] Support standalone(one read-write instance) and replication(one read-write instance and multiple read-only instances, for read write splitting).

## Usage

```hcl
module "redis" {
  source = "..."

  infrastructure = {
    vpc_id        = "..."
  }
}
```

## Examples

- [Replication](./examples/replication)
- [Standalone](./examples/standalone)

## Contributing

Please read our [contributing guide](./docs/CONTRIBUTING.md) if you're interested in contributing to Walrus template.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_network.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_redis_instance.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance) | resource |
| [google_service_networking_connection.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [random_string.name_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture"></a> [architecture](#input\_architecture) | Specify the deployment architecture, select from standalone or replication. | `string` | `"standalone"` | no |
| <a name="input_context"></a> [context](#input\_context) | Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.<br><br>Examples:<pre>context:<br>  project:<br>    name: string<br>    id: string<br>  environment:<br>    name: string<br>    id: string<br>  resource:<br>    name: string<br>    id: string</pre> | `map(any)` | `{}` | no |
| <a name="input_engine_parameters"></a> [engine\_parameters](#input\_engine\_parameters) | Specify the deployment parameters, see https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Instance.FIELDS.redis_configs | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Specify the deployment engine version, select from 7.0, 6.0, 5.0, 4.0, 3.2. | `string` | `"7.0"` | no |
| <a name="input_infrastructure"></a> [infrastructure](#input\_infrastructure) | Specify the infrastructure information for deploying.<br><br>Examples:<pre>infrastructure:<br>  vpc_id: string, optional                  # the ID of the VPC where the Redis service applies. It is a fully-qualified resource name, such as projects/{project_id}/global/networks/{network_id}.</pre> | <pre>object({<br>    vpc_id = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_replication_readonly_replicas"></a> [replication\_readonly\_replicas](#input\_replication\_readonly\_replicas) | Specify the number of read-only replicas under the replication deployment. | `number` | `1` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | Specify the computing resources.<br>Select from BASIC, STANDARD\_HA.Choosing the computing resource is also related to the storage resource, please view the specification document for more information.<br><br>Examples:<pre>resources:<br>  class: string, optional            # https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Tier</pre> | <pre>object({<br>    class = optional(string, "STANDARD_HA")<br>  })</pre> | <pre>{<br>  "class": "STANDARD_HA"<br>}</pre> | no |
| <a name="input_storage"></a> [storage](#input\_storage) | Specify the Redis memory storage size in gigabytes.<br>Examples:<pre>storage:<br>  size: number, optional         # in gigabytes</pre> | <pre>object({<br>    size = optional(number, 5)<br>  })</pre> | <pre>{<br>  "size": 5<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | The address, a string only has host, might be a comma separated string or a single string. |
| <a name="output_address_readonly"></a> [address\_readonly](#output\_address\_readonly) | The readonly address, a string only has host, might be a comma separated string or a single string. |
| <a name="output_connection"></a> [connection](#output\_connection) | The connection, a string combined host and port, might be a comma separated string or a single string. |
| <a name="output_connection_readonly"></a> [connection\_readonly](#output\_connection\_readonly) | The readonly connection, a string combined host and port, might be a comma separated string or a single string. |
| <a name="output_context"></a> [context](#output\_context) | The input context, a map, which is used for orchestration. |
| <a name="output_password"></a> [password](#output\_password) | The password of the account to access the database. |
| <a name="output_port"></a> [port](#output\_port) | The port of the service. |
| <a name="output_refer"></a> [refer](#output\_refer) | The refer, a map, including hosts, ports and account, which is used for dependencies or collaborations. |
<!-- END_TF_DOCS -->
