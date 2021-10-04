resource "aws_iam_instance_profile" "bastion-instance-profile" {
  name = "army_bastion_instance_profile"
  role = aws_iam_role.bastion-instance-role.name
}

data "aws_iam_policy_document" "bastion-instance-policy-doc" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      # these permissions are necessary for the ec2 instance to associate itself with
      # an elastic IP address on startup
      "ec2:DescribeAddresses",
      "ec2:AllocateAddress",
      "ec2:DescribeInstances",
      "ec2:AssociateAddress"
    ]

    effect = "Allow"

    resources = ["*"]
  }
}

resource "aws_iam_policy" "bastion-instance-policy" {
  name   = "bastion-instance-policy"
  policy = data.aws_iam_policy_document.bastion-instance-policy-doc.json
}

resource "aws_iam_role" "bastion-instance-role" {
  name = "bastion-instance-role"
  path = "/"

  tags = merge(local.tags, { Name = "bastion-instance-role" })

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Effect": "Allow",
        "Principal": {"Service": "ec2.amazonaws.com"},
        "Action": "sts:AssumeRole"
    }
]
}
EOF
}

resource "aws_iam_role_policy_attachment" "bastion-instance-policy-attachment" {
  role       = aws_iam_role.bastion-instance-role.name
  policy_arn = aws_iam_policy.bastion-instance-policy.arn
}
