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