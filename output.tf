
#EFS
output "efs_id" {
  description = "The ID that identifies the file system (e.g., `fs-ccfc0d65`)"
  value       = module.efs.id
}

output "efs_access_point_id" {
  value = module.efs.access_point_id["root_example"]
}


# VPC
output "private_subnets" {
  description = "The ID of the private subnet"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_subnets
}
