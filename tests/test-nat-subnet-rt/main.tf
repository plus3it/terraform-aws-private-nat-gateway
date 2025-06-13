module "nat_gateway" {
  for_each = { for i, az in local.azs : az => { az = az, index = i } }
  source   = "../../"

  nat_gateway = {
    # In this scenario, we create new subnets to host the private "intra-nat" natgws.
    # The private natgws will nat traffic from the intra subnets created by the
    # vpc module and send it out the public natgw.

    name = "${local.test_name}-intra-nat-${each.value.az}"
    tags = local.tags

    subnet = {
      availability_zone = each.value.az
      cidr_block        = cidrsubnet(local.vpc_cidr, 8, each.value.index + 56)
      name              = "${local.test_name}-intra-nat-${each.value.az}"
    }

    route_table = {
      name = "${local.test_name}-intra-nat-${each.value.az}"
    }

    vpc = {
      id = module.vpc.vpc_id
    }

    routes = [
      {
        # Route traffic *from* intra subnets *to* the private intra-nat
        name                   = "self-nat-default"
        destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id         = "self"
        route_table_id         = element(module.vpc.intra_route_table_ids, each.value.index)
      },
      {
        # Route traffic *from* the private intra-nat *to* the public natgw
        name                   = "self-rt-public-natgw"
        destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id         = one(module.vpc.natgw_ids)
        route_table_id         = "self"
      },
    ]
  }
}

locals {
  test_id   = random_string.test_id.result
  test_base = replace(basename(abspath(path.root)), "_", "-")
  test_name = "${local.test_base}-${local.test_id}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Test = local.test_base
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.test_name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for i, v in local.azs : cidrsubnet(local.vpc_cidr, 4, i)]
  public_subnets  = [for i, v in local.azs : cidrsubnet(local.vpc_cidr, 8, i + 48)]
  intra_subnets   = [for i, v in local.azs : cidrsubnet(local.vpc_cidr, 8, i + 52)]

  create_multiple_intra_route_tables = true

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

resource "random_string" "test_id" {
  length  = 6
  upper   = false
  special = false
  numeric = false
}

data "aws_availability_zones" "available" {}
