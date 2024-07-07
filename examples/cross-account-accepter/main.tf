terraform {
  required_version = "~>1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
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
  region           = ""
  peering_accepter = true

  tags = {
    managedBy   = "terraform"
    CostGroup   = "Phoenix"
    Environment = "OM2-PhoenixIntegrations"
    repo        = "terraform-aws-vpc-peering"
  }

  peering_requests = {
    octopus = {
      create                = true
      peering_connection_id = ""
      requester_vpc_id      = ""
      accepter_vpc_id       = ""
      accepter_region       = local.region
      account_id            = ""
      requester_cidr        = "10.250.0.0/16"
      accepter_cidr         = "172.30.0.0/16"
    }
  }
}

module "vpc_peering_cross_account_accept" {
  source = "../../"

  for_each = local.peering_requests

  name   = join("-", ["vpc_peering_cross_account", each.key])
  create = local.peering_accepter

  requester_vpc_id     = each.value.requester_vpc_id
  requester_cidr_block = each.value.requester_cidr

  accepter_enabled                         = local.peering_accepter
  peering_connection_id_to_accept          = each.value.peering_connection_id
  accepter_vpc_id                          = each.value.accepter_vpc_id
  auto_accept                              = true
  accepter_allow_remote_vpc_dns_resolution = false
  open_local_security_group_rule           = false

}
