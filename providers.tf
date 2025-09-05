terraform {
  required_version = ">=1.7.0, <1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.100.0"
    }
  }
}

provider "aws" {
  region = var.accepter_region != "" ? var.accepter_region : data.aws_region.current.name
  alias  = aws.accepter

  default_tags {
    tags = var.accepter_vpc_tags
  }
}
