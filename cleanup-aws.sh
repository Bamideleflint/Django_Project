#!/bin/bash

# AWS Infrastructure Cleanup Script
# This script destroys all AWS resources created by Terraform

echo "🧹 AWS Infrastructure Cleanup"
echo "=============================="
echo ""
echo "⚠️  WARNING: This will destroy all AWS resources created by Terraform!"
echo "This includes:"
echo "  - EC2 instances"
echo "  - Security groups"
echo "  - Any associated resources"
echo ""

read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Cleanup cancelled."
    exit 0
fi

echo ""
echo "📍 Navigating to terraform directory..."
cd /home/bamideleflint/Django-App/Django_Project/terraform

echo "🔍 Checking current infrastructure state..."
terraform show

echo ""
echo "🗑️  Destroying infrastructure..."
terraform destroy -auto-approve

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SUCCESS! All AWS resources have been destroyed."
    echo ""
    echo "💰 You should no longer be billed for these resources."
    echo ""
    echo "📊 Verify on AWS Console:"
    echo "   - EC2 Dashboard: Check no instances are running"
    echo "   - VPC Dashboard: Check security groups are removed"
else
    echo ""
    echo "❌ ERROR: Terraform destroy failed."
    echo "Please check the errors above and try again."
    echo ""
    echo "Manual cleanup may be required in AWS Console."
    exit 1
fi
