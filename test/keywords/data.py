# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2022] Technogix SARL
# All rights reserved
# -------------------------------------------------------
# Keywords to create data for module test
# -------------------------------------------------------
# Nadège LEMPERIERE, @13 november 2021
# Latest revision: 13 november 2021
# -------------------------------------------------------

# System includes
from json import load, dumps

# Robotframework includes
from robot.libraries.BuiltIn import BuiltIn, _Misc
from robot.api import logger as logger
from robot.api.deco import keyword
ROBOT = False

# ip address manipulation
from ipaddress import IPv4Network

@keyword('Load Standard Test Data')
def load_standard_test_data(loggroup, role, account) :

    result = {}
    result['loggroup'] = []
    result['loggroup'].append({})
    result['loggroup'][0]['name'] = 'group'
    result['loggroup'][0]['data'] = {}
    result['loggroup'][0]['data']['logGroupName'] = 'test-test-test'
    result['loggroup'][0]['data']['retentionInDays'] =  30
    result['loggroup'][0]['data']['arn'] = loggroup['arn'] + ':*'
    result['loggroup'][0]['data']['kmsKeyId'] = loggroup['key']
    result['loggroup'][0]['data']['Tags'] = {'Version' : 'test', 'Project' : 'test', 'Module' : 'test', 'Environment' : 'test', 'Owner' : 'moi.moi@moi.fr', 'Name' : 'test.test.test.test.loggroup'}


    result['role'] = []
    result['role'].append({})
    result['role'][0]['name'] = 'role'
    result['role'][0]['data'] = {}
    result['role'][0]['data']['RoleName'] = 'test-test-test'
    result['role'][0]['data']['RoleId'] = role['unique']
    result['role'][0]['data']['Arn'] = role['arn']
    result['role'][0]['data']['AssumeRolePolicyDocument'] = {"Version": "2012-10-17", "Statement": [{"Effect": "Allow", "Principal": {"Service": ["cloudtrail.amazonaws.com", "config.amazonaws.com", "sns.amazonaws.com"]}, "Action": "sts:AssumeRole"}]}

    result['key'] = []
    result['key'].append({})
    result['key'][0]['name'] = 'role'
    result['key'][0]['data'] = {}
    result['key'][0]['data']['KeyId'] = loggroup['key'].split('/')[1]
    result['key'][0]['data']['Arn'] = loggroup['key']
    result['key'][0]['data']['Enabled'] = True
    result['key'][0]['data']['KeyUsage'] = 'ENCRYPT_DECRYPT'
    result['key'][0]['data']['KeyState'] = 'Enabled'
    result['key'][0]['data']['Origin'] = 'AWS_KMS'
    result['key'][0]['data']['CustomerMasterKeySpec'] = 'SYMMETRIC_DEFAULT'
    result['key'][0]['data']['AWSAccountId'] = account
    result['key'][0]['data']['Policy'] = {"Version" : "2012-10-17","Statement" : [ {"Sid" : "AllowLogGroupWriters", "Effect" : "Allow", "Principal" : { "Service" : "logs.eu-west-1.amazonaws.com" }, "Action" : [ "kms:GenerateDataKey", "kms:Describe*", "kms:Encrypt*", "kms:Decrypt*", "kms:ReEncrypt*" ], "Resource" : "*"  }, {"Sid" : "AllowRootAndServicePrincipal", "Effect" : "Allow", "Principal" : {"AWS" : [ "arn:aws:iam::833168553325:user/god", "arn:aws:iam::833168553325:root" ]}, "Action" : "kms:*", "Resource" : "*"  } ]}

    logger.debug(dumps(result))

    return result
