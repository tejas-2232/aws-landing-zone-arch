variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
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

variable "terraform_state_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
}

variable "terraform_state_region" {
  description = "Region for Terraform state bucket"
  type        = string
  default     = "us-east-1"
}

variable "terraform_state_dynamodb_table" {
  description = "DynamoDB table for Terraform state locking"
  type        = string
}

variable "allowed_regions" {
  description = "List of allowed AWS regions"
  type        = list(string)
  default     = ["us-east-1", "us-east-2", "us-west-1", "us-west-2"]
}

variable "required_tags" {
  description = "Map of required tags for all resources"
  type        = map(string)
  default = {
    Project     = "LandingZone"
    Environment = "Management"
    ManagedBy   = "Terraform"
  }
} 