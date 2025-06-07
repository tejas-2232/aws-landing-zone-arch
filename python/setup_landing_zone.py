#!/usr/bin/env python3
"""
AWS Landing Zone Setup Script
This script automates the initial setup of AWS Landing Zone components.
Author: @tejas-2232 (Tejas)
"""

import boto3
import logging
import sys
from typing import Dict, List
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class AWSLandingZone:
    def __init__(self):
        """Initialize AWS clients."""
        self.orgs = boto3.client('organizations')
        self.iam = boto3.client('iam')
        self.config = boto3.client('config')
        self.securityhub = boto3.client('securityhub')
        
    def check_organizations_enabled(self) -> bool:
        """Check if AWS Organizations is enabled."""
        try:
            response = self.orgs.describe_organization()
            return True
        except ClientError as e:
            if e.response['Error']['Code'] == 'AWSOrganizationsNotInUseException':
                logger.error("AWS Organizations is not enabled")
                return False
            raise

    def create_organizational_units(self) -> Dict[str, str]:
        """Create the basic organizational units structure."""
        ou_structure = {
            'Core': ['Security', 'Logging', 'SharedServices'],
            'Workloads': ['Production', 'Staging', 'Development'],
            'Sandbox': ['Testing', 'Training']
        }
        
        created_ous = {}
        
        try:
            root_id = self.orgs.list_roots()['Roots'][0]['Id']
            
            for parent_ou, child_ous in ou_structure.items():
                # Create parent OU
                parent_response = self.orgs.create_organizational_unit(
                    ParentId=root_id,
                    Name=parent_ou
                )
                parent_ou_id = parent_response['OrganizationalUnit']['Id']
                created_ous[parent_ou] = parent_ou_id
                
                # Create child OUs
                for child_ou in child_ous:
                    child_response = self.orgs.create_organizational_unit(
                        ParentId=parent_ou_id,
                        Name=child_ou
                    )
                    created_ous[child_ou] = child_response['OrganizationalUnit']['Id']
                    
            return created_ous
            
        except ClientError as e:
            logger.error(f"Error creating OUs: {e}")
            raise

    def setup_security_hub(self) -> None:
        """Enable and configure AWS Security Hub."""
        try:
            # Enable Security Hub
            self.securityhub.enable_security_hub(
                EnableDefaultStandards=True,
                Tags=[
                    {
                        'Key': 'Project',
                        'Value': 'LandingZone'
                    }
                ]
            )
            
            # Enable security standards
            standards = self.securityhub.get_enabled_standards()
            logger.info(f"Enabled standards: {standards}")
            
        except ClientError as e:
            logger.error(f"Error setting up Security Hub: {e}")
            raise

    def setup_aws_config(self) -> None:
        """Configure AWS Config."""
        try:
            # Enable AWS Config
            self.config.put_configuration_recorder(
                ConfigurationRecorder={
                    'name': 'default',
                    'roleARN': self._get_or_create_config_role(),
                    'recordingGroup': {
                        'allSupported': True,
                        'includeGlobalResources': True
                    }
                }
            )
            
            # Start configuration recorder
            self.config.start_configuration_recorder(
                ConfigurationRecorderName='default'
            )
            
        except ClientError as e:
            logger.error(f"Error setting up AWS Config: {e}")
            raise

    def _get_or_create_config_role(self) -> str:
        """Get or create IAM role for AWS Config."""
        role_name = 'AWSConfigRole'
        try:
            response = self.iam.get_role(RoleName=role_name)
            return response['Role']['Arn']
        except ClientError:
            # Create the role if it doesn't exist
            trust_policy = {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Principal": {
                            "Service": "config.amazonaws.com"
                        },
                        "Action": "sts:AssumeRole"
                    }
                ]
            }
            
            self.iam.create_role(
                RoleName=role_name,
                AssumeRolePolicyDocument=str(trust_policy)
            )
            
            # Attach AWS managed policy for Config
            self.iam.attach_role_policy(
                RoleName=role_name,
                PolicyArn='arn:aws:iam::aws:policy/service-role/AWS_ConfigRole'
            )
            
            return self.iam.get_role(RoleName=role_name)['Role']['Arn']

def main():
    """Main execution function."""
    try:
        landing_zone = AWSLandingZone()
        
        # Check if Organizations is enabled
        if not landing_zone.check_organizations_enabled():
            logger.error("Please enable AWS Organizations before proceeding")
            sys.exit(1)
            
        # Create OU structure
        logger.info("Creating Organizational Units...")
        ous = landing_zone.create_organizational_units()
        logger.info(f"Created OUs: {ous}")
        
        # Setup Security Hub
        logger.info("Setting up Security Hub...")
        landing_zone.setup_security_hub()
        
        # Setup AWS Config
        logger.info("Setting up AWS Config...")
        landing_zone.setup_aws_config()
        
        logger.info("Landing Zone setup completed successfully!")
        
    except Exception as e:
        logger.error(f"Error during setup: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main() 