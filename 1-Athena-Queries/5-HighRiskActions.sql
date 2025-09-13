SELECT
  eventTime,
  eventName,
  userIdentity.userName,
  sourceIPAddress
FROM cloudtrail_logs.cloudtrail_events
WHERE eventName IN ('DeleteBucket', 'PutBucketPolicy', 'DeleteObject', 
                    'AuthorizeSecurityGroupIngress', 'AuthorizeSecurityGroupEgress',
                    'ModifyVpcPeeringConnectionOptions')
ORDER BY eventTime DESC
LIMIT 20;
