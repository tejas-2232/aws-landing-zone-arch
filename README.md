# 🚀 AWS Enterprise Landing Zone Architecture 🚀 

A comprehensive, automated solution for implementing AWS Landing Zone using Infrastructure as Code (IaC) and following AWS best practices.

## Features

- **Multi-Account Architecture**: Automated provisioning of AWS accounts using AWS Organizations
- **Security First**: Implementation of baseline security controls using AWS Security Hub and AWS Config
- **Identity Management**: Centralized identity management using IAM Identity Center (Successor to AWS SSO)
- **Infrastructure as Code**: Complete infrastructure defined using Terraform and CloudFormation
- **Automation**: Python-based automation scripts for account provisioning and configuration
- **Compliance**: Built-in compliance checks and automated remediation
- **Cost Management**: Automated cost allocation and budget controls
- **Monitoring**: Centralized logging and monitoring setup

## Architecture

```
├── accounts/
│   ├── core/           # Core accounts (Logging, Security, Shared Services)
│   ├── workload/       # Workload accounts
│   └── sandbox/        # Development and testing accounts
├── terraform/          # Terraform configurations
├── cloudformation/     # CloudFormation templates
├── python/            # Automation scripts
├── docs/              # Documentation
└── tests/             # Test cases
```

## Prerequisites

- AWS CLI v2
- Terraform v1.0+
- Python 3.8+
- AWS Organizations enabled
- AWS Control Tower (optional)

## Getting Started

1. Clone this repository
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Configure AWS credentials
4. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```
## Policies

## Service Control policies

__Purpose:__ It prevents the use of root user credentials across all accounts in your AWS Organizations. This is security best practice because:

* root users have unrestricted access to all resources
* root users can't be restricted by IAM policies
* root users can't be monitored through AWS CloudTrail in the same way as IAM users 

__How it works?:__
* The `Effect:"Deny"` explicitly blocks the specified actions
* `"Action": "*"` means it applies to all AWS actions
* `"Resource": "*" ` means it applies to all AWS resources
* The condition block specifically targets root users by matching their ARN pattern ( `arn:aws:iam::*:root`)

__Impact:__
* This policy will prevent any root user from performing actions in any account where this policy is attached
* It forces the use of IAM users and roles instead, which can be properly managed and monitored
* It helps enforce the princile of least privilege

__Best Practice:__
* This policy is typically attached at the root level of your AWS Organizations
* It's one of the first security controls you should implement in a multi-account AWS environment
* It's a part of AWS's security best practices for enterprise environments

__Example:__

`deny_root_access.json` file , is a Service Control Policy for AWS Organizations. To break it down:-

```json
{
    "Version": "2012-10-17",  // Standard AWS policy version
    "Statement": [
        {
            "Sid": "DenyRootAccess",  // Statement ID for identification
            "Effect": "Deny",         // Explicitly denies the specified actions
            "Action": "*",            // Applies to all AWS actions
            "Resource": "*",          // Applies to all resources
            "Condition": {
                "StringLike": {
                    "aws:PrincipalArn": [
                        "arn:aws:iam::*:root"  // Matches any root user ARN
                    ]
                }
            }
        }
    ]
}
```
## Tag policy:
This policy is important for several reasons:

__Purpose:__

* Enforces consistent tagging across all AWS accounts in your organization
* Helps with cost allocation, resource management, and compliance
* Makes it easier to track and manage resources across multiple accounts

__Required Tags:__u
* Project: Must be "LandingZone" (enforces project identification)
* Environment: Must be one of the predefined environments (helps with resource categorization)
* ManagedBy: Must indicate how the resource is managed (helps with operations)

__How it works:__

* The @@assign operator enforces the exact values that can be used
* Resources must have all three tags
* Tag values must match exactly what's specified in the policy
* Any attempts to use different tag keys or values will be rejected

__Benefits:__

* Cost Management: Makes it easier to track costs by project and environment
* Resource Organization: Helps identify resources across accounts
* Compliance: Ensures consistent tagging for compliance requirements
* Automation: Supports automated resource management and cleanup
* Security: Helps with access control and security policies

__Example:__

```json
{
    "tags": {
        "Project": {
            "tag_key": {
                "@@assign": "Project"  // Enforces the tag key name
            },
            "tag_value": {
                "@@assign": [
                    "LandingZone"      // Only allows this specific value
                ]
            }
        },
        "Environment": {
            "tag_key": {
                "@@assign": "Environment"  // Enforces the tag key name
            },
            "tag_value": {
                "@@assign": [
                    "Management",      // Allowed environment values
                    "Production",
                    "Staging",
                    "Development",
                    "Testing",
                    "Training"
                ]
            }
        },
        "ManagedBy": {
            "tag_key": {
                "@@assign": "ManagedBy"    // Enforces the tag key name
            },
            "tag_value": {
                "@@assign": [
                    "Terraform",           // Allowed management methods
                    "CloudFormation",
                    "Manual"
                ]
            }
        }
    }
}
```

## Documentation

Detailed documentation is available in the `docs/` directory:
- [Architecture Overview](docs/architecture.md)
- [Setup Guide](docs/setup.md)
- [Security Controls](docs/security.md)
- [Automation Guide](docs/automation.md)

## Security

This project implements AWS security best practices including:
- AWS Security Hub integration
- AWS Config rules
- AWS GuardDuty
- AWS CloudTrail
- AWS Organizations SCPs

## Cost Management

- Automated cost allocation tags
- Budget alerts
- Resource optimization recommendations

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- AWS Well-Architected Framework
- AWS Landing Zone Solution
- AWS Control Tower 