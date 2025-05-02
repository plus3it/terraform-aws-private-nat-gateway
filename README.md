# terraform-aws-private-nat-gateway

Terraform module to manage a *private* AWS NAT Gateway

<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nat_gateway"></a> [nat\_gateway](#input\_nat\_gateway) | Object of inputs for Private NAT Gateway configuration | <pre>object({<br/>    name = string<br/>    tags = optional(map(string))<br/><br/>    subnet = object({<br/>      create     = optional(bool, false)<br/>      id         = optional(string)<br/>      cidr_block = optional(string)<br/>      name       = optional(string)<br/>      tags       = optional(map(string))<br/>    })<br/><br/>    route_table = optional(object({<br/>      create = optional(bool, false)<br/>      tags   = optional(map(string))<br/>      name   = optional(string)<br/>    }), {})<br/><br/>    vpc = optional(object({<br/>      id = string<br/>    }))<br/><br/>    routes = optional(list(object({<br/>      name           = string<br/>      route_table_id = string<br/><br/>      destination_cidr_block      = optional(string)<br/>      destination_ipv6_cidr_block = optional(string)<br/>      destination_prefix_list_id  = optional(string)<br/><br/>      carrier_gateway_id        = optional(string)<br/>      core_network_arn          = optional(string)<br/>      egress_only_gateway_id    = optional(string)<br/>      gateway_id                = optional(string)<br/>      local_gateway_id          = optional(string)<br/>      nat_gateway_id            = optional(string)<br/>      network_interface_id      = optional(string)<br/>      transit_gateway_id        = optional(string)<br/>      vpc_endpoint_id           = optional(string)<br/>      vpc_peering_connection_id = optional(string)<br/>    })), [])<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.

<!-- END TFDOCS -->
