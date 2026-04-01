#!/bin/bash
set -e

PROFILE="${AWS_PROFILE:-default}"
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=nsse-production-vpc" \
  --query "Vpcs[0].VpcId" --output text --profile "$PROFILE")

import_if_exists() {
  local name=$1
  local resource=$2

  SG_ID=$(aws ec2 describe-security-groups \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=group-name,Values=$name" \
    --query "SecurityGroups[0].GroupId" --output text --profile "$PROFILE" 2>/dev/null)

  if [ "$SG_ID" != "None" ] && [ -n "$SG_ID" ]; then
    echo "Importando $name ($SG_ID)..."
    terraform import "$resource" "$SG_ID" || true
  fi
}

import_if_exists "nsse-production-control-plane-security-group" "aws_security_group.control_plane"
import_if_exists "nsse-production-worker-security-group" "aws_security_group.worker"

terraform apply -auto-approve
