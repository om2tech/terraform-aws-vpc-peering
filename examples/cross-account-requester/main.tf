terraform {
  required_version = ">=1.7.0, <1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.90.0"
    }
  }
}

locals {
  region = ""

  tags = {
    managedBy   = "terraform"
    CostGroup   = "Phoenix"
    Environment = "OM2-PhoenixIntegrations"
    repo        = "terraform-aws-vpc-peering"
  }

  peering_requests = {
    test = {
      create      = true
      peer_vpc_id = ""
      peer_region = ""
      account_id  = ""
      cidr_block  = "172.30.0.0/16"
    }
  }
}


provider "aws" {
  region = local.region
  default_tags {
    tags = local.tags
  }
}

module "vpc" {
  source  = "app.terraform.io/TOMS/vpc/aws"
  version = "0.15.0"

  az_primary            = "a"
  az_secondary          = "b"
  az_tertiary           = "c"
  az_primary_db_ro      = "a"
  az_secondary_db_ro    = "b"
  az_tertiary_db_ro     = "c"
  domain                = "om2.com"
  name                  = "om2-phoenixpoc-vpc"
  public_hosted_zone_id = ""
  cidr_prefix           = "10.250"
}

resource "aws_security_group" "peering" {
  name        = "Internal-Peering"
  description = "A security group for all peering needs specified in the name. Ingress rule changes in Terraform will be ignored. Rules will be managed by VPC peering module in separate workspaces"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name   = "Internal-Peering"
    Entity = "sg"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ingress]
  }
}

module "vpc_peering_request" {
  source = "../../"

  for_each = local.peering_requests

  name   = join("-", ["vpc_peering_cross_account", each.key])
  create = each.value.create

  requester_vpc_id                          = module.vpc.vpc_id
  requester_allow_remote_vpc_dns_resolution = false
  open_local_security_group_rule            = false

  accepter_account_id = each.value.account_id
  accepter_vpc_id     = each.value.peer_vpc_id
  accepter_region     = each.value.peer_region
  accepter_cidr_block = each.value.cidr_block
  auto_accept         = false
}
