SELECT
  userIdentity.userName AS user,
  sourceIPAddress AS ip,
  COUNT(*) AS failed_attempts
FROM cloudtrail_logs.cloudtrail_events
WHERE eventName = 'ConsoleLogin'
  AND errorMessage IS NOT NULL
GROUP BY userIdentity.userName, sourceIPAddress
HAVING COUNT(*) > 5
ORDER BY failed_attempts DESC
LIMIT 50;
