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
  region = try(var.accepter_region, data.aws_region.current.region)
  alias  = "accepter"

  default_tags {
    tags = var.accepter_vpc_tags
  }
}
