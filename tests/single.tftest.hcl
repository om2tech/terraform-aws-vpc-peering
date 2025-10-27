# For a functioning test please first create the VPC's in the relevant workpaces in OM2Phoenix organization
variables {
  accepter_allow_remote_vpc_dns_resolution  = true
  accepter_cidr_block                       = "10.128.0.0/16"
  accepter_enabled                          = true
  accepter_vpc_id                           = "vpc-0bdf46d09297644fa"
  accepter_auto_accept                      = true
  create                                    = true
  accepter_open_local_security_group_rule   = true
  requester_open_local_security_group_rule  = true
  name                                      = "terraform-autotest-vpcpeering"
  requester_allow_remote_vpc_dns_resolution = true
  requester_cidr_block                      = "10.127.0.0/16"
  requester_enabled                         = true
  requester_vpc_id                          = "vpc-0bdd46d09287644fe"
  #accepter_cidr_block                       = run.vpc_accepter.cidr_block
  #accepter_vpc_id                           = run.vpc_accepter.id
  #requester_cidr_block                      = run.vpc_requester.cidr_block
  #requester_vpc_id                          = run.vpc_requester.id
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      managedBy   = "terraform"
      CostGroup   = "Phoenix"
      Environment = "terraform-autotest"
      repo        = "terraform-aws-vpc-peering"
      Purpose     = "test"
      Stack       = "test"
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

run "peering" {

  assert {
    condition     = can(output.requester_peering_connection_id) && output.requester_peering_connection_id == output.accepter_peering_connection_id
    error_message = "Peering connection not created successfully. Missing connection ID"
  }

  assert {
    condition     = output.accepter_accept_status != "failed"
    error_message = "Peering connection status failed."
  }
}
