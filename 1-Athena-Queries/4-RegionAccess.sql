SELECT
  eventTime,
  eventName,
  awsRegion,
  userIdentity.userName,
  sourceIPAddress
FROM cloudtrail_logs.cloudtrail_events
WHERE awsRegion NOT IN ('ap-south-1') 
ORDER BY eventTime DESC
LIMIT 20;
