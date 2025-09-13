SELECT
  userIdentity.userName,
  eventName,
  COUNT(*) AS call_count
FROM cloudtrail_logs.cloudtrail_events
GROUP BY userIdentity.userName, eventName
HAVING COUNT(*) > 50
ORDER BY call_count DESC
LIMIT 20;
