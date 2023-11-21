# -------------------------------------------------------
# Copyright (c) [2022] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Robotframework test suite for module
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 20 november 2023
# -------------------------------------------------------


*** Settings ***
Documentation   A test case to check loggroup creation using module
Library         aws_iac_keywords.terraform
Library         aws_iac_keywords.keepass
Library         aws_iac_keywords.cloudwatch
Library         aws_iac_keywords.iam
Library         aws_iac_keywords.kms
Library         ../keywords/data.py
Library         OperatingSystem


*** Variables ***
${KEEPASS_DATABASE}                 ${vault_database}
${KEEPASS_KEY_ENV}                  ${vault_key_env}
${KEEPASS_PRINCIPAL_KEY_ENTRY}      /aws/aws-principal-access-key
${KEEPASS_ACCOUNT_ENTRY}            /aws/aws-account
${KEEPASS_PRINCIPAL_USERNAME}       /aws/aws-principal-credentials
${REGION}                           eu-west-1

*** Test Cases ***
Prepare environment
    [Documentation]         Retrieve principal credential from database and initialize python tests keywords
    ${keepass_key}          Get Environment Variable          ${KEEPASS_KEY_ENV}
    ${principal_access}     Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}    username
    ${principal_secret}     Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}    password
    ${ACCOUNT}              Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_ACCOUNT_ENTRY}          password
    ${principal_name}       Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_USERNAME}     username
    Initialize Terraform    ${REGION}   ${principal_access}   ${principal_secret}
    Initialize Cloudwatch   None        ${principal_access}   ${principal_secret}    ${REGION}
    Initialize IAM          None        ${principal_access}   ${principal_secret}    ${REGION}
    Initialize KMS          None        ${principal_access}   ${principal_secret}    ${REGION}
    ${TF_PARAMETERS}=       Create Dictionary   account=${ACCOUNT}    service_principal=${principal_name}
    Set Global Variable     ${TF_PARAMETERS}
    Set Global Variable     ${ACCOUNT}

Create Standard Loggroup
    [Documentation]         Create Loggroup And Check That The AWS Infrastructure Match Specifications
    Launch Terraform Deployment                 ${CURDIR}/../data/standard  ${TF_PARAMETERS}
    ${states}   Load Terraform States           ${CURDIR}/../data/standard
    ${specs}    Load Standard Test Data         ${states['test']['outputs']['loggroup']['value']}    ${states['test']['outputs']['role']['value']}    ${ACCOUNT}
    Loggroups Shall Exist And Match             ${specs['loggroup']}
    Role Shall Exist And Match                  ${specs['role']}
    Key Shall Exist And Match                   ${specs['key']}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/standard  ${TF_PARAMETERS}
