variable "nat_gateway" {
  description = "Object of inputs for Private NAT Gateway configuration"
  type = object({
    name = string
    tags = optional(map(string))

    subnet = object({
      create     = optional(bool, false)
      id         = optional(string)
      cidr_block = optional(string)
      name       = optional(string)
      tags       = optional(map(string))
    })

    route_table = optional(object({
      create = optional(bool, false)
      tags   = optional(map(string))
      name   = optional(string)
    }), {})

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
    condition = !var.nat_gateway.subnet.create ? alltrue([
      var.nat_gateway.subnet.id != null,
    ]) : true
    error_message = "It is required to provide `subnet.id` when `subnet.create` is false."
  }

  validation {
    condition = var.nat_gateway.subnet.create ? alltrue([
      var.nat_gateway.vpc != null,
    ]) : true
    error_message = "It is required to provide `vpc.id` when `subnet.create` is true."
  }

  validation {
    condition = var.nat_gateway.route_table.create ? alltrue([
      var.nat_gateway.vpc != null,
    ]) : true
    error_message = "It is required to provide `vpc.id` when `route_table.create` is true."
  }
}
