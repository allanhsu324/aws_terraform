output "kms_key" {
  description = "The KMS customer master key to encrypt state buckets."
  value       = module.terraform_remote_state.kms_key.key_id
}

output "state_bucket" {
  description = "The S3 bucket to store the remote state file."
  value       = module.terraform_remote_state.state_bucket.bucket
}

output "dynamodb_table" {
  description = "The dynamodb table to store id for locking terraform."
  value       = module.terraform_remote_state.dynamodb_table.id
}