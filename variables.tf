# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2022] Technogix SARL
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws loggroup with all the secure
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @01 december 2021
# Latest revision: 01 december 2021
# -------------------------------------------------------

terraform {
	experiments = [ module_variable_optional_attrs ]
}

# -------------------------------------------------------
# Contact e-mail for this deployment
# -------------------------------------------------------
variable "email" {
	type 	= string
}

# -------------------------------------------------------
# Environment for this deployment (prod, preprod, ...)
# -------------------------------------------------------
variable "environment" {
	type 	= string
}

# -------------------------------------------------------
# AWS region
# -------------------------------------------------------
variable "region" {
	type 	= string
}

# -------------------------------------------------------
# Topic context for this deployment
# -------------------------------------------------------
variable "project" {
	type    = string
}
variable "module" {
	type 	= string
}

# -------------------------------------------------------
# Solution version
# -------------------------------------------------------
variable "git_version" {
	type    = string
	default = "unmanaged"
}

# -------------------------------------------------------
# Loggroup name
# -------------------------------------------------------
variable "name" {
	type = string
}

# -------------------------------------------------------
# Retentions in days
# -------------------------------------------------------
variable "retention" {
	type = string
}

# -------------------------------------------------------
# Allowed users for encrypt / decrypt
# -------------------------------------------------------
variable "service_principal" {
	type = string
}
variable "account" {
	type = string
}

# -------------------------------------------------------
# Allowed writers
# -------------------------------------------------------
variable "writers" {
	type = object({
		aws 		= optional(list(string))
		services 	= optional(list(string))
	})
	default = null
}

# -------------------------------------------------------
# Allowed readers
# -------------------------------------------------------
variable "readers" {
	type = object({
		aws 		= optional(list(string))
		services 	= optional(list(string))
	})
	default = null
}