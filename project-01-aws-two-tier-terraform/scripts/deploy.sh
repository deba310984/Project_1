#!/bin/bash
# deploy.sh — safe, ordered Terraform workflow. Run from the project root.
# Requires: terraform, AWS credentials configured, and TF_VAR_db_password set.
set -euo pipefail

cd "$(dirname "$0")/../terraform"

: "${TF_VAR_db_password:?Set TF_VAR_db_password before deploying (e.g. export TF_VAR_db_password=...)}"

echo "==> fmt"
terraform fmt -check -recursive
echo "==> init"
terraform init -input=false
echo "==> validate"
terraform validate
echo "==> plan"
terraform plan -out=tfplan
echo
echo "Review the plan above. To create these (PAID) resources, run:"
echo "    terraform apply tfplan"
echo "Nothing has been created yet."
