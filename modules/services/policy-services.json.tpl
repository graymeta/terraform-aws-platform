{
    "Statement": [
        {
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ecs:RunTask",
                "ecs:RegisterTaskDefinition"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "${file_storage_s3_bucket_arn}"
            ]
        },
        {
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "${file_storage_s3_bucket_arn}/*"
            ]
        },
        {
            "Action": [
                "sqs:*"
            ],
            "Effect": "Allow",
            "Resource": [
                "${sqs_activity_arn}",
                "${sqs_index_arn}",
                "${sqs_stage_arn}",
                "${sqs_walk_arn}"
            ]
        },
        {
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Condition": {
                "StringEquals": {
                    "ses:FromAddress": "${from_addr}"
                }
            },
            "Effect": "Allow",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
