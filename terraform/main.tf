terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  backend "s3" {
    # These values will be provided during terraform init
    # bucket         = "your-terraform-state-bucket"
    # key            = "landing-zone/terraform.tfstate"
    # region         = "us-east-1"
    # dynamodb_table = "terraform-state-lock"
    # encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "LandingZone"
      Environment = "Management"
      ManagedBy   = "Terraform"
    }
  }
}

# AWS Organizations
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "sso.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "ram.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
    "ipam.amazonaws.com"
  ]
  
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY"
  ]
  
  feature_set = "ALL"
}

# Core Organizational Units
resource "aws_organizations_organizational_unit" "core" {
  name      = "Core"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = aws_organizations_organization.org.roots[0].id
}

# Core Sub-OUs
resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organizational_unit.core.id
}

resource "aws_organizations_organizational_unit" "logging" {
  name      = "Logging"
  parent_id = aws_organizations_organizational_unit.core.id
}

resource "aws_organizations_organizational_unit" "shared_services" {
  name      = "SharedServices"
  parent_id = aws_organizations_organizational_unit.core.id
}

# Workload Sub-OUs
resource "aws_organizations_organizational_unit" "production" {
  name      = "Production"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "staging" {
  name      = "Staging"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_organizational_unit" "development" {
  name      = "Development"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

# Sandbox Sub-OUs
resource "aws_organizations_organizational_unit" "testing" {
  name      = "Testing"
  parent_id = aws_organizations_organizational_unit.sandbox.id
}

resource "aws_organizations_organizational_unit" "training" {
  name      = "Training"
  parent_id = aws_organizations_organizational_unit.sandbox.id
}

# Service Control Policies
resource "aws_organizations_policy" "deny_root_access" {
  name        = "DenyRootAccess"
  description = "Deny root user access"
  content     = file("${path.module}/policies/deny_root_access.json")
}

resource "aws_organizations_policy_attachment" "deny_root_access" {
  policy_id = aws_organizations_policy.deny_root_access.id
  target_id = aws_organizations_organization.org.roots[0].id
}

# Tag Policies
resource "aws_organizations_policy" "tag_policy" {
  name        = "TagPolicy"
  description = "Enforce required tags"
  content     = file("${path.module}/policies/tag_policy.json")
}

resource "aws_organizations_policy_attachment" "tag_policy" {
  policy_id = aws_organizations_policy.tag_policy.id
  target_id = aws_organizations_organization.org.roots[0].id
} 