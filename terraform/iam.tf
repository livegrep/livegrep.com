
resource "aws_iam_role" "livegrep_frontend" {
  name = "livegrep_frontend"
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
}

resource "aws_iam_instance_profile" "livegrep_frontend" {
    name = "livegrep_frontend"
    roles = ["${aws_iam_role.livegrep_frontend.name}"]
}

resource "aws_iam_role" "livegrep_backend" {
  name = "livegrep_backend"
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
}

resource "aws_iam_instance_profile" "livegrep_backend" {
    name = "livegrep_backend"
    roles = ["${aws_iam_role.livegrep_backend.name}"]
}

resource "aws_iam_policy" "livegrep_s3" {
    name = "livegrep-s3-ro"
    path = "/"
    description = "readonly access to the livegrep S3 bucket"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:HeadObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::livegrep/*",
                "arn:aws:s3:::livegrep"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "livegrep_credstash_ddb" {
    name = "livegrep-credstash-ddb"
    path = "/"
    description = "readonly access to the credstash table"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:Scan",
                "dynamodb:GetItem",
                "dynamodb:Query"
            ],
            "Resource": [
                "arn:aws:dynamodb:${var.region}:807717602072:table/credential-store"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "livegrep_s3_attachment" {
  name = "livegrep-s3-ro-attach"
  roles = [
    "${aws_iam_role.livegrep_frontend.name}",
    "${aws_iam_role.livegrep_backend.name}",
  ]
  policy_arn = "${aws_iam_policy.livegrep_s3.arn}"
}

resource "aws_iam_policy_attachment" "livegrep_credstash_attachment" {
  name = "livegrep-credstash-ro-attach"
  roles = [
    "${aws_iam_role.livegrep_frontend.name}",
    "${aws_iam_role.livegrep_backend.name}",
  ]
  policy_arn = "${aws_iam_policy.livegrep_credstash_ddb.arn}"
}

resource "aws_iam_role_policy" "livegrep_frontend_r53" {
    name = "livegrep_frontend_r53"
    role = "${aws_iam_role.livegrep_frontend.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1450992162000",
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "ManageIntZone",
            "Effect": "Allow",
            "Action": [
                "route53:ListResourceRecordSets",
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/Z3M7BVOL8R3KUV"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "livegrep_backend_r53" {
    name = "livegrep_backend_r53"
    role = "${aws_iam_role.livegrep_backend.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1450992162000",
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "ManageIntZone",
            "Effect": "Allow",
            "Action": [
                "route53:ListResourceRecordSets",
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/${aws_route53_zone.int_livegrep_com.id}"
            ]
        }
    ]
}
EOF
}
