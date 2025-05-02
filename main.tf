resource "aws_nat_gateway" "this" {
  connectivity_type = "private"
  subnet_id         = var.nat_gateway.subnet.create ? aws_subnet.this[0].id : var.nat_gateway.subnet.id

  tags = merge(
    var.nat_gateway.tags,
    { "Name" = var.nat_gateway.name },
  )
}

resource "aws_subnet" "this" {
  count = var.nat_gateway.subnet.create ? 1 : 0

  vpc_id     = var.nat_gateway.vpc.id
  cidr_block = var.nat_gateway.subnet.cidr_block

  tags = merge(
    var.nat_gateway.tags,
    var.nat_gateway.subnet.tags,
    { "Name" = var.nat_gateway.subnet.name },
  )
}

resource "aws_route_table" "this" {
  count = var.nat_gateway.route_table.create ? 1 : 0

  vpc_id = var.nat_gateway.vpc.id

  tags = merge(
    var.nat_gateway.tags,
    var.nat_gateway.route_table.tags,
    { "Name" = var.nat_gateway.route_table.name },
  )
}

resource "aws_route_table_association" "this" {
  count = var.nat_gateway.route_table.create ? 1 : 0

  route_table_id = aws_route_table.this[0].id
  subnet_id      = var.nat_gateway.subnet.create ? aws_subnet.this[0].id : var.nat_gateway.subnet.id
}

resource "aws_route" "this" {
  for_each = { for route in var.nat_gateway.routes : route.name => route }

  route_table_id = each.value.route_table_id == "self" ? aws_route_table.this[0].id : each.value.route_table_id

  destination_cidr_block      = each.value.destination_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block
  destination_prefix_list_id  = each.value.destination_prefix_list_id

  carrier_gateway_id        = each.value.carrier_gateway_id
  core_network_arn          = each.value.core_network_arn
  egress_only_gateway_id    = each.value.egress_only_gateway_id
  gateway_id                = each.value.gateway_id
  local_gateway_id          = each.value.local_gateway_id
  nat_gateway_id            = each.value.nat_gateway_id == "self" ? aws_nat_gateway.this.id : each.value.nat_gateway_id
  network_interface_id      = each.value.network_interface_id
  transit_gateway_id        = each.value.transit_gateway_id
  vpc_endpoint_id           = each.value.vpc_endpoint_id
  vpc_peering_connection_id = each.value.vpc_peering_connection_id

  lifecycle {
    precondition {
      condition = anytrue([
        each.value.destination_cidr_block == null && each.value.destination_ipv6_cidr_block == null,
        each.value.destination_cidr_block == null && each.value.destination_prefix_list_id == null,
        each.value.destination_ipv6_cidr_block == null && each.value.destination_prefix_list_id == null,
      ])
      error_message = "Exactly one destination type must be provided, but multiple were detected."
    }

    precondition {
      condition = anytrue([
        each.value.destination_cidr_block != null,
        each.value.destination_ipv6_cidr_block != null,
        each.value.destination_prefix_list_id != null,
      ])
      error_message = "Exactly one destination type must be provided, but none were set."
    }
  }
}
