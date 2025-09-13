SELECT
  eventTime,
  eventName,
  sourceIPAddress,
  userAgent
FROM cloudtrail_logs.cloudtrail_events
WHERE userIdentity.type = 'Root'
ORDER BY eventTime DESC
LIMIT 20;
