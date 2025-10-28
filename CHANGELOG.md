# Version: 1.0.0


#### Changes

* [#12](https://github.com/om2tech/terraform-aws-vpc-peering/pull/12): MPA-21606 - Removes accepter provider in favor it to be send from outside so to allow for_each and count, fixes accepter route table entries injection, adds option to allow SG rule injection from each side
* [#13](https://github.com/om2tech/terraform-aws-vpc-peering/pull/13): MPA-21606 - Fixes route tables rules creation from requester side


# Version: 0.3.0


#### Changes

* [#10](https://github.com/om2tech/terraform-aws-vpc-peering/pull/10): MPA-19340 - Bumps Terraform version to 1.13, bumps all providers and modules versions


# Version: 0.2.0


#### Changes

* [#8](https://github.com/om2tech/terraform-aws-vpc-peering/pull/8): MPA-21578 - Adds regional provider for Accepter resources, Sets TF provider version limit till major version upgrade, updates GitHub workflows actions' versions, updates pre-commit hooks versions


# Version: 0.1.0


#### Changes

* [#1](https://github.com/om2tech/terraform-aws-vpc-peering/pull/1): Adds Terraform configuration files and GitHub workflows for public vpc peering repo


# terraform-aws-vpc-peering
