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
  accepter_region  = ""

  accepter_allow_remote_vpc_dns_resolution  = true
  accepter_cidr_block                       = "10.128.0.0/16"
  accepter_vpc_id                           = "vpc-0bdf46d09297644fa"
  open_local_security_group_rule            = true
  name                                      = "terraform-autotest-vpcpeering"
  requester_allow_remote_vpc_dns_resolution = true
  requester_cidr_block                      = "10.127.0.0/16"
  requester_vpc_id                          = "vpc-0bdd46d09287644fe"

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
  default_tags {
    tags = local.tags
  }
}

provider "aws_accepter" {
  region = local.accepter_region
  default_tags {
    tags = local.tags
  }
}

module "vpc" {
  provider = aws
  source   = "app.terraform.io/TOMS/vpc/aws"
  version  = "0.10.1"

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

module "vpc" {
  provider = aws_accepter
  source   = "app.terraform.io/TOMS/vpc/aws"
  version  = "0.10.1"

  az_primary            = "a"
  az_secondary          = "b"
  az_tertiary           = "c"
  az_primary_db_ro      = "a"
  az_secondary_db_ro    = "b"
  az_tertiary_db_ro     = "c"
  domain                = "om2.com"
  name                  = "om2-phoenixpoc-vpc"
  public_hosted_zone_id = ""
  cidr_prefix           = "10.251"
}


module "vpc_peering_request" {
  source   = "../../"
  provider = aws

  for_each = local.peering_requests

  name   = join("-", ["vpc_peering_cross_account", each.key])
  create = each.value.create

  requester_enabled                         = true
  requester_vpc_id                          = module.vpc.vpc_id
  requester_allow_remote_vpc_dns_resolution = false
  open_local_security_group_rule            = false

  accepter_enabled    = false
  accepter_account_id = each.value.account_id
  accepter_vpc_id     = each.value.peer_vpc_id
  accepter_region     = each.value.peer_region
  accepter_cidr_block = each.value.cidr_block
  auto_accept         = false
}


module "vpc_peering_accept" {
  source   = "../../"
  provider = aws_accepter

  for_each = local.peering_requests

  name   = join("-", ["vpc_peering_cross_account", each.key])
  create = each.value.create

  requester_enabled                         = false
  requester_vpc_id                          = module.vpc.vpc_id
  requester_allow_remote_vpc_dns_resolution = false
  open_local_security_group_rule            = false

  accepter_enabled    = true
  accepter_account_id = each.value.account_id
  accepter_vpc_id     = each.value.peer_vpc_id
  accepter_region     = each.value.peer_region
  accepter_cidr_block = each.value.cidr_block
  auto_accept         = true

  lifecycle {
    depends_on = [module.vpc_peering_request]
  }
}
