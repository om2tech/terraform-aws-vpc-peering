## terraform-aws-vpc-peering

A module allowing for easy request and acceptance of VPC peering connections between two VPCs.
VPCs may be in different accounts and/or different regions.
The requester should be configured and run first, followed by the accepter.
If both requester and accepter are in the same account then the connection can be auto-accepted.

## Usage

In order to use this in a single account it is enough to configure a single provider.
In this auto_accept can be set to true and the accepter will automatically accept the peering connection.

In order to configure a peering connection between separate accounts it is recommended to define the module twice, 
once for the requester and once for the accepter.
Each definition should be assigend a provider with the relvant permissions in the relevant accounts

This module can be used to create one-way peering connection requests which will only be accepted later
This will only require defining the requester. The accpeter will need to accept and configure the required
security posture on the other end.

In order to successfully set peering options for the reuqester VPC, the peering connection must be accepted.
This requires either:
- The requester and accepter to be in the same account
- A provider with permissions in each account to accept at time of apply or within the configured timeout.
- The accepter to be an accept resouce managed by a third party cloud provider, ex. CloudAMQP.

## Contributing

Please feel free to fork this repo and create a PR.

Use pre-commit-terraform docker image to run pre-commit checks.
These will include:
- terraform fmt
- terraform docs

More checks can be added to the .pre-commit-config.yaml file

Additional checks such as terraform test have been added in the scripts pre-commit.sh and pre-commit.ps1
Feel free to run either.

## Licensing

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details

## Singing off

This repo requires all commits to be signed off. 
This can be done by adding the --sign-off flag to the git commit command.

Signing off on commits is a declaration that you have followed all guidelines defined in the [DCO.md](DCO.md)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.57.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group_rule.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc_peering_connection.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [random_string.test](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_route_table.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_tables.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.accepter_default_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.requester_default_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_security_group.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_account_id"></a> [accepter\_account\_id](#input\_accepter\_account\_id) | Accepter account ID | `string` | `""` | no |
| <a name="input_accepter_allow_remote_vpc_dns_resolution"></a> [accepter\_allow\_remote\_vpc\_dns\_resolution](#input\_accepter\_allow\_remote\_vpc\_dns\_resolution) | Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC | `bool` | `true` | no |
| <a name="input_accepter_cidr_block"></a> [accepter\_cidr\_block](#input\_accepter\_cidr\_block) | cidr block for accepter's VPC | `string` | `null` | no |
| <a name="input_accepter_enabled"></a> [accepter\_enabled](#input\_accepter\_enabled) | Flag to enable/disable the accepter side of the peering connection | `bool` | `false` | no |
| <a name="input_accepter_region"></a> [accepter\_region](#input\_accepter\_region) | Accepter AWS region | `string` | `""` | no |
| <a name="input_accepter_route_table_tags"></a> [accepter\_route\_table\_tags](#input\_accepter\_route\_table\_tags) | Only add peer routes to accepter VPC route tables matching these tags | `map(string)` | `{}` | no |
| <a name="input_accepter_security_group_name"></a> [accepter\_security\_group\_name](#input\_accepter\_security\_group\_name) | The name of the security group in the accepter VPC to allow traffic from the requester VPC<br>  The security group should already exist in the accepter VPC | `string` | `"Internal-Peering"` | no |
| <a name="input_accepter_subnet_tags"></a> [accepter\_subnet\_tags](#input\_accepter\_subnet\_tags) | Only add peer routes to accepter VPC route tables of subnets matching these tags | `map(string)` | `{}` | no |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | Accepter VPC ID filter | `string` | n/a | yes |
| <a name="input_accepter_vpc_tags"></a> [accepter\_vpc\_tags](#input\_accepter\_vpc\_tags) | Accepter VPC Tags filter | `map(string)` | `{}` | no |
| <a name="input_auto_accept"></a> [auto\_accept](#input\_auto\_accept) | Automatically accept the peering | `bool` | `true` | no |
| <a name="input_aws_route_create_timeout"></a> [aws\_route\_create\_timeout](#input\_aws\_route\_create\_timeout) | Time to wait for AWS route creation specifed as a Go Duration, e.g. `2m` | `string` | `"5m"` | no |
| <a name="input_aws_route_delete_timeout"></a> [aws\_route\_delete\_timeout](#input\_aws\_route\_delete\_timeout) | Time to wait for AWS route deletion specifed as a Go Duration, e.g. `5m` | `string` | `"5m"` | no |
| <a name="input_create"></a> [create](#input\_create) | A boolean value to control creation of VPC peering connection | `bool` | `true` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | VPC peering connection create timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"30m"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | VPC peering connection delete timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"5m"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the peering connection | `string` | n/a | yes |
| <a name="input_open_local_security_group_rule"></a> [open\_local\_security\_group\_rule](#input\_open\_local\_security\_group\_rule) | Define whether or not to inject the required security group rule into the local security group defined by the variables accepter\_security\_group\_name and requester\_security\_group\_name. If not then this rule should be added in the calling module directly to the required SG | `bool` | `false` | no |
| <a name="input_peering_connection_id_to_accept"></a> [peering\_connection\_id\_to\_accept](#input\_peering\_connection\_id\_to\_accept) | ID of the VPC Peering connection to accept. Only in-use for accepter-only workspaces. | `string` | `null` | no |
| <a name="input_requester_allow_remote_vpc_dns_resolution"></a> [requester\_allow\_remote\_vpc\_dns\_resolution](#input\_requester\_allow\_remote\_vpc\_dns\_resolution) | Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC | `bool` | `true` | no |
| <a name="input_requester_cidr_block"></a> [requester\_cidr\_block](#input\_requester\_cidr\_block) | The CIDR block of the requester that will be used in accepter | `string` | `""` | no |
| <a name="input_requester_enabled"></a> [requester\_enabled](#input\_requester\_enabled) | Whether or not to accept peering connection requested from remote account | `bool` | `false` | no |
| <a name="input_requester_route_table_tags"></a> [requester\_route\_table\_tags](#input\_requester\_route\_table\_tags) | Only add peer routes to requester VPC route tables matching these tags | `map(string)` | `{}` | no |
| <a name="input_requester_security_group_name"></a> [requester\_security\_group\_name](#input\_requester\_security\_group\_name) | The name of the security group in the requester VPC to allow traffic from the accepter VPC<br>  The security group should already exist in the requester VPC | `string` | `"Internal-Peering"` | no |
| <a name="input_requester_subnet_tags"></a> [requester\_subnet\_tags](#input\_requester\_subnet\_tags) | Only add peer routes to requester VPC route tables of subnets matching these tags | `map(string)` | `{}` | no |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | requester VPC ID | `string` | n/a | yes |
| <a name="input_requester_vpc_tags"></a> [requester\_vpc\_tags](#input\_requester\_vpc\_tags) | Requester VPC Tags filter | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the VPC peering connection | `map(string)` | `{}` | no |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | VPC peering connection update timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"30m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accepter_accept_status"></a> [accepter\_accept\_status](#output\_accepter\_accept\_status) | Requester VPC peering connection request status |
| <a name="output_accepter_peering_connection_id"></a> [accepter\_peering\_connection\_id](#output\_accepter\_peering\_connection\_id) | ID of the peering connection |
| <a name="output_accepter_subnet_route_table_map"></a> [accepter\_subnet\_route\_table\_map](#output\_accepter\_subnet\_route\_table\_map) | Map of accepter VPC subnet IDs to route table IDs |
| <a name="output_requester_accept_status"></a> [requester\_accept\_status](#output\_requester\_accept\_status) | Requester VPC peering connection request status |
| <a name="output_requester_cidr"></a> [requester\_cidr](#output\_requester\_cidr) | CIRD of the peering connection |
| <a name="output_requester_peering_connection_id"></a> [requester\_peering\_connection\_id](#output\_requester\_peering\_connection\_id) | ID of the peering connection |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.57.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group_rule.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc_peering_connection.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [random_string.test](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_route_table.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_tables.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.accepter_default_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.requester_default_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_security_group.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_account_id"></a> [accepter\_account\_id](#input\_accepter\_account\_id) | Accepter account ID | `string` | `""` | no |
| <a name="input_accepter_allow_remote_vpc_dns_resolution"></a> [accepter\_allow\_remote\_vpc\_dns\_resolution](#input\_accepter\_allow\_remote\_vpc\_dns\_resolution) | Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC | `bool` | `true` | no |
| <a name="input_accepter_cidr_block"></a> [accepter\_cidr\_block](#input\_accepter\_cidr\_block) | cidr block for accepter's VPC | `string` | `null` | no |
| <a name="input_accepter_enabled"></a> [accepter\_enabled](#input\_accepter\_enabled) | Flag to enable/disable the accepter side of the peering connection | `bool` | `false` | no |
| <a name="input_accepter_region"></a> [accepter\_region](#input\_accepter\_region) | Accepter AWS region | `string` | `""` | no |
| <a name="input_accepter_route_table_tags"></a> [accepter\_route\_table\_tags](#input\_accepter\_route\_table\_tags) | Only add peer routes to accepter VPC route tables matching these tags | `map(string)` | `{}` | no |
| <a name="input_accepter_security_group_name"></a> [accepter\_security\_group\_name](#input\_accepter\_security\_group\_name) | The name of the security group in the accepter VPC to allow traffic from the requester VPC<br>  The security group should already exist in the accepter VPC | `string` | `"Internal-Peering"` | no |
| <a name="input_accepter_subnet_tags"></a> [accepter\_subnet\_tags](#input\_accepter\_subnet\_tags) | Only add peer routes to accepter VPC route tables of subnets matching these tags | `map(string)` | `{}` | no |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | Accepter VPC ID filter | `string` | n/a | yes |
| <a name="input_accepter_vpc_tags"></a> [accepter\_vpc\_tags](#input\_accepter\_vpc\_tags) | Accepter VPC Tags filter | `map(string)` | `{}` | no |
| <a name="input_auto_accept"></a> [auto\_accept](#input\_auto\_accept) | Automatically accept the peering | `bool` | `true` | no |
| <a name="input_aws_route_create_timeout"></a> [aws\_route\_create\_timeout](#input\_aws\_route\_create\_timeout) | Time to wait for AWS route creation specifed as a Go Duration, e.g. `2m` | `string` | `"5m"` | no |
| <a name="input_aws_route_delete_timeout"></a> [aws\_route\_delete\_timeout](#input\_aws\_route\_delete\_timeout) | Time to wait for AWS route deletion specifed as a Go Duration, e.g. `5m` | `string` | `"5m"` | no |
| <a name="input_create"></a> [create](#input\_create) | A boolean value to control creation of VPC peering connection | `bool` | `true` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | VPC peering connection create timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"30m"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | VPC peering connection delete timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"5m"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the peering connection | `string` | n/a | yes |
| <a name="input_open_local_security_group_rule"></a> [open\_local\_security\_group\_rule](#input\_open\_local\_security\_group\_rule) | Define whether or not to inject the required security group rule into the local security group defined by the variables accepter\_security\_group\_name and requester\_security\_group\_name. If not then this rule should be added in the calling module directly to the required SG | `bool` | `false` | no |
| <a name="input_peering_connection_id_to_accept"></a> [peering\_connection\_id\_to\_accept](#input\_peering\_connection\_id\_to\_accept) | ID of the VPC Peering connection to accept. Only in-use for accepter-only workspaces. | `string` | `null` | no |
| <a name="input_requester_allow_remote_vpc_dns_resolution"></a> [requester\_allow\_remote\_vpc\_dns\_resolution](#input\_requester\_allow\_remote\_vpc\_dns\_resolution) | Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC | `bool` | `true` | no |
| <a name="input_requester_cidr_block"></a> [requester\_cidr\_block](#input\_requester\_cidr\_block) | The CIDR block of the requester that will be used in accepter | `string` | `""` | no |
| <a name="input_requester_enabled"></a> [requester\_enabled](#input\_requester\_enabled) | Whether or not to accept peering connection requested from remote account | `bool` | `false` | no |
| <a name="input_requester_route_table_tags"></a> [requester\_route\_table\_tags](#input\_requester\_route\_table\_tags) | Only add peer routes to requester VPC route tables matching these tags | `map(string)` | `{}` | no |
| <a name="input_requester_security_group_name"></a> [requester\_security\_group\_name](#input\_requester\_security\_group\_name) | The name of the security group in the requester VPC to allow traffic from the accepter VPC<br>  The security group should already exist in the requester VPC | `string` | `"Internal-Peering"` | no |
| <a name="input_requester_subnet_tags"></a> [requester\_subnet\_tags](#input\_requester\_subnet\_tags) | Only add peer routes to requester VPC route tables of subnets matching these tags | `map(string)` | `{}` | no |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | requester VPC ID | `string` | n/a | yes |
| <a name="input_requester_vpc_tags"></a> [requester\_vpc\_tags](#input\_requester\_vpc\_tags) | Requester VPC Tags filter | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the VPC peering connection | `map(string)` | `{}` | no |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | VPC peering connection update timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"30m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accepter_accept_status"></a> [accepter\_accept\_status](#output\_accepter\_accept\_status) | Requester VPC peering connection request status |
| <a name="output_accepter_peering_connection_id"></a> [accepter\_peering\_connection\_id](#output\_accepter\_peering\_connection\_id) | ID of the peering connection |
| <a name="output_accepter_subnet_route_table_map"></a> [accepter\_subnet\_route\_table\_map](#output\_accepter\_subnet\_route\_table\_map) | Map of accepter VPC subnet IDs to route table IDs |
| <a name="output_requester_accept_status"></a> [requester\_accept\_status](#output\_requester\_accept\_status) | Requester VPC peering connection request status |
| <a name="output_requester_cidr"></a> [requester\_cidr](#output\_requester\_cidr) | CIRD of the peering connection |
| <a name="output_requester_peering_connection_id"></a> [requester\_peering\_connection\_id](#output\_requester\_peering\_connection\_id) | ID of the peering connection |
<!-- END_TF_DOCS -->
