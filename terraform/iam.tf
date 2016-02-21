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

resource "aws_iam_role" "livegrep_indexer" {
  name = "livegrep_indexer"
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

resource "aws_iam_instance_profile" "livegrep_indexer" {
    name = "livegrep_indexer"
    roles = ["${aws_iam_role.livegrep_indexer.name}"]
}


resource "aws_iam_policy" "livegrep_common" {
    name = "livegrep-common"
    path = "/"
    description = "livegrep base IAM policy"
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
          "arn:aws:s3:::${var.s3_bucket}/*",
          "arn:aws:s3:::${var.s3_bucket}"
        ]
      },
      {
        "Sid": "ReadCredstash",
        "Effect": "Allow",
        "Action": [
          "dynamodb:Scan",
          "dynamodb:GetItem",
          "dynamodb:Query"
        ],
        "Resource": [
          "arn:aws:dynamodb:${var.region}:${var.account_id}:table/credential-store"
        ]
      },
      {
        "Sid": "DescribeInstances",
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ],
        "Resource": "*"
      },
      {
        "Sid": "CredstashDecryptCommon",
        "Effect": "Allow",
        "Action": [
          "kms:Decrypt"
        ],
        "Resource": ["arn:aws:kms:${var.region}:${var.account_id}:key/${var.credstash_keyid}"],
        "Condition": {
          "StringEquals": {
            "kms:EncryptionContext:role": [
              "base",
              "mailgun",
              "papertrail",
              "datadog"
            ]
          }
        }
      },
      {
        "Sid": "CompleteLifecyleAction",
        "Effect": "Allow",
        "Action": [
          "autoscaling:CompleteLifeCycleAction"
        ],
        "Resource": "*"
      },
      {
        "Sid": "ReadLifecyleEvents",
        "Effect": "Allow",
        "Action": [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:ChangeMessageVisibility",
          "sqs:Get*"
        ],
        "Resource": ["${aws_sqs_queue.livegrep_asg_queue.arn}"]
      }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "livegrep_common_attachment" {
  name = "livegrep-common-attachment"
  roles = [
    "${aws_iam_role.livegrep_frontend.name}",
    "${aws_iam_role.livegrep_backend.name}",
    "${aws_iam_role.livegrep_indexer.name}",
  ]
  policy_arn = "${aws_iam_policy.livegrep_common.arn}"
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

resource "aws_iam_role_policy" "livegrep_frontend_creds" {
    name = "livegrep_frontend_creds"
    role = "${aws_iam_role.livegrep_frontend.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "CredstashDecryptFrontend",
        "Effect": "Allow",
        "Action": [
          "kms:Decrypt"
        ],
        "Resource": ["arn:aws:kms:${var.region}:${var.account_id}:key/${var.credstash_keyid}"],
        "Condition": {
          "StringEquals": {
            "kms:EncryptionContext:role": [
              "letsencrypt",
              "livegrep-web"
            ]
          }
        }
      },
      {
        "Sid": "CredstashEncryptCerts",
        "Effect": "Allow",
        "Action": [
          "kms:GenerateDataKey"
        ],
        "Resource": ["arn:aws:kms:${var.region}:${var.account_id}:key/${var.credstash_keyid}"],
        "Condition": {
          "StringEquals": {
            "kms:EncryptionContext:role": [
              "livegrep-web"
            ]
          }
        }
      },
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem"
        ],
        "Resource": [
          "arn:aws:dynamodb:${var.region}:${var.account_id}:table/credential-store"
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


resource "aws_iam_role_policy" "livegrep_indexer_s3" {
    name = "livegrep_indexer_s3"
    role = "${aws_iam_role.livegrep_indexer.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject"
        ],
        "Resource": [
          "arn:aws:s3:::${var.s3_bucket}/indexes/*"
        ]
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "livegrep_indexer_ebs" {
    name = "livegrep_indexer_ebs"
    role = "${aws_iam_role.livegrep_indexer.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AttachVolume",
        "Effect": "Allow",
        "Action": [
          "ec2:AttachVolume"
        ],
        "Resource": [
          "arn:aws:ec2:${var.region}:${var.account_id}:volume/${aws_ebs_volume.indexer_cache.id}",
          "arn:aws:ec2:${var.region}:${var.account_id}:instance/*"
        ]
      },
      {
        "Sid": "DescribeVolumes",
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeVolumes"
        ],
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "livegrep_indexer_creds" {
    name = "livegrep_indexer_creds"
    role = "${aws_iam_role.livegrep_indexer.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "CredstashIndexerFrontend",
        "Effect": "Allow",
        "Action": [
          "kms:Decrypt"
        ],
        "Resource": ["arn:aws:kms:${var.region}:${var.account_id}:key/${var.credstash_keyid}"],
        "Condition": {
          "StringEquals": {
            "kms:EncryptionContext:role": [
              "livegrep-indexer"
            ]
          }
        }
      }
    ]
}
EOF
}

# ASG notification policies
resource "aws_iam_role" "livegrep_autoscale" {
  name = "livegrep_autoscale"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "livegrep_autoscale" {
  name = "livegrep-autoscale"
  roles = ["${aws_iam_role.livegrep_autoscale.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AutoScalingNotificationAccessRole"
}


resource "aws_sqs_queue" "livegrep_asg_queue" {
  name = "livegrep-asg"
  message_retention_seconds = 3600
}
