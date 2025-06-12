variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "terraform_state_bucket" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
}

variable "terraform_state_dynamodb_table" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "management"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "LandingZone"
} 