variables {
  accepter_allow_remote_vpc_dns_resolution  = true
  accepter_cidr_block                       = "10.128.0.0/16"
  accepter_region                           = "eu-west-2"
  accepter_vpc_id                           = "vpc-ABCDEFGHIJKL"
  auto_accept                               = false
  create                                    = true
  open_local_security_group_rule            = true
  name                                      = "terraform-autotest-vpcpeering"
  requester_allow_remote_vpc_dns_resolution = true
  requester_cidr_block                      = "10.127.0.0/16"
  requester_region                          = "eu-west-1"
  requester_vpc_id                          = "vpc-1234567890"
  #accepter_cidr_block                       = run.vpc_accepter.cidr_block
  #accepter_vpc_id                           = run.vpc_accepter.id
  #requester_cidr_block                      = run.vpc_requester.cidr_block
  #requester_vpc_id                          = run.vpc_requester.id
}

provider "aws" {
  alias  = "requester"
  region = "eu-west-1"
  default_tags {
    tags = {
      managedBy   = "terraform"
      CostGroup   = "Phoenix"
      Environment = "OM2-PhoenixIntegrations"
      repo        = "terraform-aws-vpc-peering"
    }
  }
}

provider "aws" {
  alias  = "accepter"
  region = "eu-west-2"
  default_tags {
    tags = {
      managedBy   = "terraform"
      CostGroup   = "Phoenix"
      Environment = "OM2-PhoenixIntegrations"
      repo        = "terraform-aws-vpc-peering"
    }
  }
}

/*
run "vpc_requester" {
  variables {
    az_primary            = "a"
    az_secondary          = "b"
    az_tertiary           = "c"
    az_primary_db_ro      = "a"
    az_secondary_db_ro    = "b"
    az_tertiary_db_ro     = "c"
    domain                = "om2.com"
    name                  = "terraform-awsvpcpeering-requester"
    public_hosted_zone_id = "Z166M0JOPOZR5U"
    region                = var.requester_region
    cidr_prefix           = "10.245"
  }

  providers = {
    aws = aws.requester
  }

  module {
    source  = "app.terraform.io/TOMS/vpc/aws"
    version = "0.16.0"
  }
}

run "vpc_accepter" {
  variables {
    az_primary            = "a"
    az_secondary          = "b"
    az_tertiary           = "c"
    az_primary_db_ro      = "a"
    az_secondary_db_ro    = "b"
    az_tertiary_db_ro     = "c"
    domain                = "om2.com"
    name                  = "terraform-awsvpcpeering-accepter"
    public_hosted_zone_id = "Z166M0JOPOZR5U"
    region                = var.accepter_region
    cidr_prefix           = "10.250"
  }

  providers = {
    aws = aws.accepter
  }

  module {
    source  = "app.terraform.io/TOMS/vpc/aws"
    version = "0.16.0"
  }
}
*/

run "requester" {

  variables {
    requester_enabled = true
  }

  providers = {
    aws = aws.requester
  }

  assert {
    condition     = can(output.peering_connection_id)
    error_message = "Peering connection not created successfully. Missing connection ID"
  }

  assert {
    condition     = output.accept_status != "failed"
    error_message = "Peering connection statuys not active."
  }
}

run "accepter" {

  variables {
    accepter_enabled                = true
    peering_connection_id_to_accept = run.requester.peering_connection_id
  }

  providers = {
    aws = aws.accepter
  }

  assert {
    condition     = can(output.peering_connection_id)
    error_message = "Peering connection not created successfully. Missing connection ID"
  }

  assert {
    condition     = output.accept_status == "active"
    error_message = "Peering connection status not active."
  }
}
