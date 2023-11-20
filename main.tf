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

# -------------------------------------------------------
# Create a log group
# -------------------------------------------------------
resource "aws_cloudwatch_log_group" "group" {

	name 				= "${var.project}-${var.environment}-${var.name}"
	retention_in_days 	= var.retention
	kms_key_id 			= aws_kms_key.key.arn

  	tags = {
		Name           	= "${var.project}.${var.environment}.${var.module}.${var.name}.loggroup"
		Environment     = var.environment
		Owner   		= var.email
		Project   		= var.project
		Version 		= var.git_version
		Module  		= var.module
	}
}

# -------------------------------------------------------
# Set permission policy for encryption key
# -------------------------------------------------------
locals {
	kms_statements = concat([
		for i,right in (("${var.readers}" != null) ? ["${var.readers}"] : []) :
		{
			Sid 		= "AllowLogGroupReaders"
			Effect 		= "Allow"
			Principal 	= {
				"AWS" 		: (("${right.aws}" != null) ? "${right.aws}" : [])
				"Service" 	: (("${right.services}" != null) ? "${right.services}" : [])
			}
			Action 		= ["kms:Decrypt", "kms:DescribeKey"],
			Resource	= ["*"]
		}
	],
	[
		for i,right in (("${var.writers}" != null) ? ["${var.writers}"] : []) :
		{
			Sid 		= "AllowLogGroupWriters"
			Effect 		= "Allow"
			Principal 	= {
				"Service": "logs.${var.region}.amazonaws.com"
			}
			Action 		= ["kms:GenerateDataKey", "kms:Describe*", "kms:Encrypt*", "kms:Decrypt*", "kms:ReEncrypt*"],
			Resource	= ["*"]
	  	}
	],
	[
		{
			Sid 		= "AllowRootAndServicePrincipal"
			Effect 		= "Allow"
			Principal 	= {
				"AWS" 		: ["arn:aws:iam::${var.account}:root", "arn:aws:iam::${var.account}:user/${var.service_principal}"]
			}
			Action 		= "kms:*",
			Resource	= ["*"]
		}
	])
}

# -------------------------------------------------------
# Bucket encryption key
# -------------------------------------------------------
resource "aws_kms_key" "key" {

	description             	= "Loggroup ${var.name} encryption key"
	key_usage					= "ENCRYPT_DECRYPT"
	customer_master_key_spec	= "SYMMETRIC_DEFAULT"
	deletion_window_in_days		= 7
	enable_key_rotation			= true
  	policy						= jsonencode({
  		Version = "2012-10-17",
  		Statement = "${local.kms_statements}"
	})

	tags = {
		Name           	= "${var.project}.${var.environment}.${var.module}.${var.name}.loggroup"
		Environment     = var.environment
		Owner   		= var.email
		Project   		= var.project
		Version 		= var.git_version
		Module  		= var.module
	}
}

# -------------------------------------------------------
# Set permission policy for s3 bucket access
# -------------------------------------------------------
locals {
	loggroup_statements = {
      	Effect 		= "Allow"
      	Principal 	=  {
			"AWS" 		: (("${var.writers}" != null && "${var.writers.aws}" != null) ? "${var.writers.aws}" : [])
			"Service" 	: (("${var.writers}" != null && "${var.writers.services}" != null) ? "${var.writers.services}" : [])
		}
    	Action 		= "sts:AssumeRole"
    }
}

# -----------------------------------------------------------
# Create role to enable writing in the loggroup
# -----------------------------------------------------------
resource "aws_iam_role" "group" {

  	name = "${var.project}-${var.environment}-${var.name}"
  	assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = "${local.loggroup_statements}"
	})
  	tags = {
		Name           	= "${var.project}.${var.environment}.${var.module}.${var.name}.loggroup"
		Environment     = var.environment
		Owner   		= var.email
		Project   		= var.project
		Version 		= var.git_version
		Module  		= var.module
	}
}

# -----------------------------------------------------------
# Create associated role policy
# -----------------------------------------------------------
resource "aws_iam_role_policy" "group" {
  	name = "${var.project}-${var.environment}-${var.name}"
  	role = aws_iam_role.group.id

  	policy = jsonencode({
  		Version = "2012-10-17",
  		Statement = [
    		{
      			Effect 	= "Allow"
      			Action  = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:DescribeLogGroups",  "logs:DescribeLogStreams"]
      			Resource: "${aws_cloudwatch_log_group.group.arn}:*"
    		},
    		{
      			Effect 	= "Allow"
      			Action = ["logs:PutLogEvents"]
      			Resource = "${aws_cloudwatch_log_group.group.arn}:*"
    		}
  		]
	})
}

