locals {
  requester_enabled = alltrue([var.create, var.requester_enabled])
  requester_count   = local.requester_enabled ? 1 : 0
}

# Lookup requester's VPC so that we can reference the CIDR
data "aws_vpc" "requester" {
  count = local.requester_count

  id   = var.requester_vpc_id
  tags = var.requester_vpc_tags
}

# Lookup requester subnets
data "aws_subnets" "requester" {
  count = local.requester_count

  filter {
    name   = "vpc-id"
    values = [var.requester_vpc_id]
  }

  tags = var.requester_subnet_tags
}

locals {
  requester_subnet_ids = local.requester_enabled ? data.aws_subnets.requester[0].ids : []
}

data "aws_route_tables" "requester" {
  for_each = toset(local.requester_subnet_ids)

  vpc_id = var.requester_vpc_id

  filter {
    name   = "association.subnet-id"
    values = [each.key]
  }
}

# If we had more subnets than routetables, we should update the default
data "aws_route_tables" "requester_default_rts" {
  count = local.requester_count

  vpc_id = var.requester_vpc_id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

data "aws_security_group" "requester" {
  count = local.requester_count

  vpc_id = var.requester_vpc_id

  filter {
    name   = "group-name"
    values = [var.requester_security_group_name]
  }
}

locals {
  requester_default_rt_id                 = try(data.aws_route_tables.requester_default_rts[0].ids, null)
  requester_rt_map                        = { for s in local.requester_subnet_ids : s => try(data.aws_route_tables.requester[s].ids[0], local.requester_default_rt_id) }
  requester_route_table_ids               = distinct(sort(values(local.requester_rt_map)))
  requester_route_table_ids_count         = length(local.requester_route_table_ids)
  requester_cidr_block_associations       = try(flatten(data.aws_vpc.requester[0].cidr_block_associations), [])
  requester_cidr_block_associations_count = length(local.requester_cidr_block_associations)
}

# Lookup requester route tables
resource "aws_vpc_peering_connection" "requester" {
  count = local.requester_count

  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  peer_owner_id = var.accepter_account_id
  peer_region   = var.accepter_region
  auto_accept   = false

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }

  tags = merge(
    var.tags,
    { Name = var.name }
  )
}

resource "aws_vpc_peering_connection_options" "requester" {
  count = var.requester_enabled ? local.accepter_count : 0

  vpc_peering_connection_id = local.requested_vpc_peering_connection_id

  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }

  depends_on = [
    aws_vpc_peering_connection_accepter.accepter
  ]
}

# Create routes from requester to accepter
resource "aws_route" "requester" {
  count = local.requester_enabled ? local.requester_route_table_ids_count : 0

  route_table_id            = local.requester_route_table_ids[count.index]
  destination_cidr_block    = var.accepter_cidr_block == "" ? data.aws_vpc.accepter[0].cidr_block : var.accepter_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester[0].id

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }

  depends_on = [
    data.aws_route_tables.requester,
    aws_vpc_peering_connection.requester,
    aws_vpc_peering_connection_accepter.accepter
  ]
}

resource "aws_security_group_rule" "requester" {
  count = var.requester_open_local_security_group_rule == true ? local.requester_count : 0

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.accepter_cidr_block == "" ? [data.aws_vpc.accepter[0].cidr_block] : [var.accepter_cidr_block]
  security_group_id = data.aws_security_group.requester[0].id
  description       = "vpc peering id: ${aws_vpc_peering_connection.requester[0].id}"
}
