terraform {
  required_version = ">=1.13.0, <1.14.0"
  # required_version = ">=1.7.0, <1.9.0" # to create a specific version for older workspaces
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.13.0"
      # version = "5.100.0" # to create a specific version for older workspaces
      configuration_aliases = [aws.accepter]
    }
  }
}
