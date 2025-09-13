SELECT
  userIdentity.userName,
  eventName,
  COUNT(*) AS delete_count
FROM cloudtrail_logs.cloudtrail_events
WHERE eventName LIKE 'Delete%'
GROUP BY userIdentity.userName, eventName
HAVING COUNT(*) > 3
ORDER BY delete_count DESC;
