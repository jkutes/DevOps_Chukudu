provider "aws" {
}

variable env_prefix {}


// work in progress - not enough experience with AWS IAM :()

module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  create_role = true
  role_name = "${var.env_prefix}-role"
  role_requires_mfa = true
}


module "iam_read_only_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-read-only-policy"

  name        = "${var.env_prefix}-policy"
  path        = "/"
  description = "My read-only policy"

  allowed_services = []
}

resource "aws_iam_role_policy_attachment" "my-policy-attach" {
  role = "${aws_iam_role.my-role.name}"
  policy_arn = "${aws_iam_policy.my-policy.arn}"
}

module "iam_group_with_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  name = "${var.env_prefix}-group"
  group_users = [
    "${var.env_prefix}-user"
  ]
  attach_iam_self_management_policy = true
}


module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  name          = "${var.env_prefix}-user"
  force_destroy = true
  pgp_key = "keybase:test"
  password_reset_required = false
}
