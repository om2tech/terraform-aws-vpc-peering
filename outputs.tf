output "accepter_accept_status" {
  value       = try(aws_vpc_peering_connection_accepter.accepter[0].accept_status, null)
  description = "Requester VPC peering connection request status"
}

output "accepter_peering_connection_id" {
  value       = try(aws_vpc_peering_connection_accepter.accepter[0].id, null)
  description = "ID of the peering connection"
}

output "accepter_subnet_route_table_map" {
  value       = local.accepter_aws_rt_map
  description = "Map of accepter VPC subnet IDs to route table IDs"
}

output "requester_accept_status" {
  value       = try(aws_vpc_peering_connection.requester[0].accept_status, null)
  description = "Requester VPC peering connection request status"
}

output "requester_cidr" {
  value       = try(data.aws_vpc.requester[0].cidr_block, null)
  description = "CIRD of the peering connection"
}

output "requester_peering_connection_id" {
  value       = try(aws_vpc_peering_connection.requester[0].id, null)
  description = "ID of the peering connection"
}
