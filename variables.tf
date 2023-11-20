# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws loggroup with all the secure
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @01 december 2021
# Latest revision: 20 november 2023
# -------------------------------------------------------


# -------------------------------------------------------
# Contact e-mail for this deployment
# -------------------------------------------------------
variable "email" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Environment for this deployment (prod, preprod, ...)
# -------------------------------------------------------
variable "environment" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# AWS region
# -------------------------------------------------------
variable "region" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Topic context for this deployment
# -------------------------------------------------------
variable "project" {
	type     = string
	nullable = false
}
variable "module" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Solution version
# -------------------------------------------------------
variable "git_version" {
	type     = string
	nullable = false
	default  = "unmanaged"
}

# -------------------------------------------------------
# Loggroup name
# -------------------------------------------------------
variable "name" {
	type     = string
	nullable = false
}

# -------------------------------------------------------
# Retentions in days
# -------------------------------------------------------
variable "retention" {
	type     = string
	nullable = false
}

# -------------------------------------------------------
# Allowed users for encrypt / decrypt
# -------------------------------------------------------
variable "service_principal" {
	type     = string
	nullable = false
}
variable "account" {
	type     = string
	nullable = false
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