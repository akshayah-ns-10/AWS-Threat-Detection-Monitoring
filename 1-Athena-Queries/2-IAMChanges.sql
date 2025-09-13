SELECT
  eventTime,
  eventName,
  userIdentity.userName,
  sourceIPAddress
FROM cloudtrail_logs.cloudtrail_events
WHERE eventSource = 'iam.amazonaws.com'
  AND eventName IN ('CreateUser', 'DeleteUser', 'AttachRolePolicy', 'DetachRolePolicy', 
                    'PutUserPolicy', 'UpdateUser', 'CreateRole', 'DeleteRole')
ORDER BY eventTime DESC
LIMIT 50;
