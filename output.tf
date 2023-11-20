# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws loggroup with all the secure
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @01 december 2021
# Latest revision: 01 december 2021
# -------------------------------------------------------

output "role" {
    value = {
        arn     = aws_iam_role.group.arn
        id      = aws_iam_role.group.id
        unique  = aws_iam_role.group.unique_id
    }
}

output "loggroup" {
    value = {
        arn     = aws_cloudwatch_log_group.group.arn
        name    = aws_cloudwatch_log_group.group.name
        id      = aws_cloudwatch_log_group.group.id
        key     = aws_kms_key.key.arn
    }
}

