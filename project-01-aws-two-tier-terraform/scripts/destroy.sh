#!/bin/bash
# destroy.sh — tear everything down to stop charges. Run from the project root.
# Requires TF_VAR_db_password set (same value used at deploy).
set -euo pipefail

cd "$(dirname "$0")/../terraform"

: "${TF_VAR_db_password:?Set TF_VAR_db_password (same as deploy) to run destroy}"

echo "This will DESTROY all resources for this project (EC2, ALB, NAT, RDS, VPC)."
echo "RDS data will be lost (skip_final_snapshot=true)."
read -r -p "Type 'destroy' to continue: " confirm
[ "$confirm" = "destroy" ] || { echo "Aborted."; exit 1; }

terraform destroy
echo
echo "After this completes, verify in the AWS console that no NAT Gateway,"
echo "ALB, EC2, or RDS instance remains (these are the billable resources)."
