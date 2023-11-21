# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Simple deployment for loggroup testing
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------

# -------------------------------------------------------
# Create loggroup using the current module
# -------------------------------------------------------
module "loggroup" {

	source 				= "../../../"
	email 				= "moi.moi@moi.fr"
	project 			= "test"
	environment 		= "test"
	module 				= "test"
	git_version 		= "test"
	name				= "test"
	retention			= 30
	service_principal 	= var.service_principal
	account				= var.account
	region				= var.region
	writers				= {
		services	= ["cloudtrail.amazonaws.com", "config.amazonaws.com", "sns.amazonaws.com"]
	}
}

# -------------------------------------------------------
# Terraform configuration
# -------------------------------------------------------
provider "aws" {
	region		= var.region
	access_key 	= var.access_key
	secret_key	= var.secret_key
}

terraform {
	required_version = ">=1.0.8"
	backend "local"	{
		path="terraform.tfstate"
	}
}

# -------------------------------------------------------
# Region for this deployment
# -------------------------------------------------------
variable "region" {
	type    = string
}
variable "account" {
	type    = string
}
variable "service_principal" {
	type    = string
}

# -------------------------------------------------------
# AWS credentials
# -------------------------------------------------------
variable "access_key" {
	type    	= string
	sensitive 	= true
}
variable "secret_key" {
	type    	= string
	sensitive 	= true
}

# -------------------------------------------------------
# Test outputs
# -------------------------------------------------------
output "loggroup" {
	value = {
		arn     = module.loggroup.loggroup.arn
        name    = module.loggroup.loggroup.name
        id      = module.loggroup.loggroup.id
		key     = module.loggroup.loggroup.key
	}
}

output "role" {
    value = {
        arn     = module.loggroup.role.arn
        id      = module.loggroup.role.id
        unique  = module.loggroup.role.unique
    }
}