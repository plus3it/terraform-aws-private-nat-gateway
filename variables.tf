variable "nat_gateway" {
  description = "Object of inputs for Private NAT Gateway configuration"
  type = object({
    name      = string
    subnet_id = optional(string)
    tags      = optional(map(string))

    subnet = optional(object({
      cidr_block = string
      name       = string
      tags       = optional(map(string))
    }))

    route_table = optional(object({
      name = string
      tags = optional(map(string))
    }))

    vpc = optional(object({
      id = string
    }))

    routes = optional(list(object({
      name           = string
      route_table_id = string

      destination_cidr_block      = optional(string)
      destination_ipv6_cidr_block = optional(string)
      destination_prefix_list_id  = optional(string)

      carrier_gateway_id        = optional(string)
      core_network_arn          = optional(string)
      egress_only_gateway_id    = optional(string)
      gateway_id                = optional(string)
      local_gateway_id          = optional(string)
      nat_gateway_id            = optional(string)
      network_interface_id      = optional(string)
      transit_gateway_id        = optional(string)
      vpc_endpoint_id           = optional(string)
      vpc_peering_connection_id = optional(string)
    })), [])
  })

  validation {
    condition = alltrue([
      var.nat_gateway.subnet == null ? var.nat_gateway.subnet_id != null : true,
      var.nat_gateway.subnet != null ? var.nat_gateway.subnet_id == null : true,
    ])
    error_message = "It is required to provide either `subnet_id` or `subnet`, not both or neither."
  }

  validation {
    condition = var.nat_gateway.subnet != null ? alltrue([
      var.nat_gateway.vpc != null,
    ]) : true
    error_message = "It is required to provide `vpc.id` when creating the subnet."
  }

  validation {
    condition = var.nat_gateway.route_table != null ? alltrue([
      var.nat_gateway.vpc != null,
    ]) : true
    error_message = "It is required to provide `vpc.id` when creating the route table."
  }
}
