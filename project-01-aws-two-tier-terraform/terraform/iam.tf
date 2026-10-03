# iam.tf — Phase 3: IAM role that lets EC2 instances be managed by SSM.
#
# Why: we open NO SSH port. Instead, instances get an IAM role granting the
# SSM agent permission to register with AWS Systems Manager, so you open a
# shell from the console/CLI over an outbound HTTPS channel. More secure:
# no key pairs, no port 22, full audit logging.

# Trust policy: who is allowed to ASSUME this role? -> the EC2 service.
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_ssm" {
  name               = "${local.name_prefix}-ec2-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  tags               = { Name = "${local.name_prefix}-ec2-ssm-role" }
}

# AWS-managed policy with exactly the permissions the SSM agent needs.
# Using the managed policy (not a hand-rolled one) is the recommended path.
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# An instance profile is the wrapper that actually attaches a role to EC2.
resource "aws_iam_instance_profile" "ec2" {
  name = "${local.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2_ssm.name
}
