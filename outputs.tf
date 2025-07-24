output "nat_gateway" {
  description = "Object of attributes for the NAT Gateway resource"
  value       = aws_nat_gateway.this
}

output "subnet" {
  description = "Object of attributes for the Subnet resource"
  value       = aws_subnet.this
}

output "route_table" {
  description = "Object of attributes for the Route Table resource"
  value       = aws_route_table.this
}

output "route_table_association" {
  description = "Object of attributes for the Route Table Association resource"
  value       = aws_route_table_association.this
}

output "routes" {
  description = "Object of attributes for the Route resources"
  value       = aws_route.this
}
