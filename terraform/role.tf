resource "aws_iam_role" "stg_role" {
  name = "stg_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value-ec2"
  }
}


# Adjuntar una política inline al rol que permite interacciones con ECR
resource "aws_iam_role_policy" "ecr_permissions" {
  name = "ecr_permissions"
  role = aws_iam_role.stg_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:GetAuthorizationToken",
        "ecr:ListImages"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}