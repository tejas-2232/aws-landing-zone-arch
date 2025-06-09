output "terraform_state_bucket" {
  description = "The name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "terraform_state_dynamodb_table" {
  description = "The name of the DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.terraform_state_lock.id
}

output "terraform_state_bucket_arn" {
  description = "The ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.arn
}

output "terraform_state_dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.terraform_state_lock.arn
} 