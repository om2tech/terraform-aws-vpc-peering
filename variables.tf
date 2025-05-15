variable "accepter_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC"
}

variable "accepter_cidr_block" {
  type        = string
  description = "CIDR block for accepter's VPC"
  default     = ""
}

variable "accepter_enabled" {
  description = "Flag to enable/disable the accepter side of the peering connection"
  type        = bool
  default     = false
}

variable "accepter_account_id" {
  type        = string
  description = "Accepter account ID"
  default     = ""
}

variable "accepter_region" {
  type        = string
  description = "Accepter AWS region"
  default     = ""
}

variable "accepter_route_table_tags" {
  type        = map(string)
  description = "Only add peer routes to accepter VPC route tables matching these tags"
  default     = {}
}

variable "accepter_security_group_name" {
  type        = string
  default     = "Internal-Peering"
  description = <<DOC
  The name of the security group in the accepter VPC to allow traffic from the requester VPC
  The security group should already exist in the accepter VPC
  DOC
}

variable "accepter_subnet_tags" {
  type        = map(string)
  description = "Only add peer routes to accepter VPC route tables of subnets matching these tags"
  default     = {}
}

variable "accepter_vpc_id" {
  type        = string
  description = "Accepter VPC ID filter"
}

variable "accepter_vpc_tags" {
  type        = map(string)
  description = "Accepter VPC Tags filter"
  default     = {}
}

variable "auto_accept" {
  type        = bool
  default     = true
  description = "Automatically accept the peering"
}

variable "aws_route_create_timeout" {
  type        = string
  default     = "5m"
  description = "Time to wait for AWS route creation specifed as a Go Duration, e.g. `2m`"
}

variable "aws_route_delete_timeout" {
  type        = string
  default     = "5m"
  description = "Time to wait for AWS route deletion specifed as a Go Duration, e.g. `5m`"
}

variable "create" {
  type        = bool
  description = "A boolean value to control creation of VPC peering connection"
  default     = true
}

variable "create_timeout" {
  type        = string
  description = "VPC peering connection create timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts"
  default     = "30m"
}

variable "delete_timeout" {
  type        = string
  description = "VPC peering connection delete timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts"
  default     = "5m"
}

variable "open_local_security_group_rule" {
  type        = bool
  description = "Define whether or not to inject the required security group rule into the local security group defined by the variables accepter_security_group_name and requester_security_group_name. If not then this rule should be added in the calling module directly to the required SG"
  default     = false
}

variable "name" {
  type        = string
  description = "Name of the peering connection"
}

variable "peering_connection_id_to_accept" {
  type        = string
  description = "ID of the VPC Peering connection to accept. Only in-use for accepter-only workspaces."
  default     = null
}

variable "requester_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
}

variable "requester_cidr_block" {
  type        = string
  description = "The CIDR block of the requester that will be used in accepter"
  default     = ""
}

variable "requester_enabled" {
  type        = bool
  description = "Whether or not to accept peering connection requested from remote account"
  default     = false
}

variable "requester_route_table_tags" {
  type        = map(string)
  description = "Only add peer routes to requester VPC route tables matching these tags"
  default     = {}
}

variable "requester_security_group_name" {
  type        = string
  default     = "Internal-Peering"
  description = <<DOC
  The name of the security group in the requester VPC to allow traffic from the accepter VPC
  The security group should already exist in the requester VPC
  DOC
}

variable "requester_subnet_tags" {
  type        = map(string)
  description = "Only add peer routes to requester VPC route tables of subnets matching these tags"
  default     = {}
}

variable "requester_vpc_id" {
  description = "requester VPC ID"
  type        = string
}

variable "requester_vpc_tags" {
  type        = map(string)
  description = "Requester VPC Tags filter"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the VPC peering connection"
  default     = {}
}

variable "update_timeout" {
  type        = string
  description = "VPC peering connection update timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts"
  default     = "30m"
}
