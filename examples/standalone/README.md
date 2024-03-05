# Standalone Example

Deploy Redis service in standalone architecture by root moudle.

```bash
# setup infrastructure
$ terraform apply -auto-approve \
  -target=google_compute_network.example \
  -target=google_compute_firewall.example \
  -target=google_compute_global_address.example \
  -target=google_service_networking_connection.example

# create service
$ terraform apply -auto-approve
```

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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.example](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_global_address.example](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_network.example](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_service_networking_connection.example](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | n/a |
| <a name="output_address_readonly"></a> [address\_readonly](#output\_address\_readonly) | n/a |
| <a name="output_connection"></a> [connection](#output\_connection) | n/a |
| <a name="output_connection_readonly"></a> [connection\_readonly](#output\_connection\_readonly) | n/a |
| <a name="output_context"></a> [context](#output\_context) | The input context, a map, which is used for orchestration. |
| <a name="output_password"></a> [password](#output\_password) | n/a |
| <a name="output_port"></a> [port](#output\_port) | n/a |
| <a name="output_refer"></a> [refer](#output\_refer) | n/a |
<!-- END_TF_DOCS -->