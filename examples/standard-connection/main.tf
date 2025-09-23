terraform {
  required_version = ">=1.13.0, <1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.13.0"
    }
  }
}

provider "aws" {
  region = local.region
  default_tags {
    tags = local.tags
  }
}

locals {
  region = "eu-west-1"

  tags = {
    managedBy   = "terraform"
    CostGroup   = "Phoenix"
    Environment = "OM2-PhoenixIntegrations"
    repo        = "terraform-aws-vpc-peering"
  }

  peering_requests = {
    test = {
      create           = true
      requester_vpc_id = "vpc-058cf57c3201ba659"
      accepter_vpc_id  = "vpc-0ab1ede4f6a59a56d"
      requester_cidr   = "10.127.0.0/16"
      accepter_cidr    = "10.128.0.0/16"
    }
  }
}

module "vpc_peering_cross_account_accept" {
  source = "../../"

  for_each = local.peering_requests

  name   = join("-", ["vpc_peering_cross_account", each.key])
  create = true

  requester_enabled                        = true
  requester_vpc_id                         = each.value.requester_vpc_id
  requester_cidr_block                     = each.value.requester_cidr
  accepter_enabled                         = true
  accepter_vpc_id                          = each.value.accepter_vpc_id
  accepter_cidr_block                      = each.value.requester_cidr
  auto_accept                              = true
  accepter_allow_remote_vpc_dns_resolution = false
  open_local_security_group_rule           = false
}
