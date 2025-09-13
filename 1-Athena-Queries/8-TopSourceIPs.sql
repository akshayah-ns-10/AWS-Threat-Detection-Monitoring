SELECT
  sourceIPAddress,
  COUNT(*) AS event_count
FROM cloudtrail_logs.cloudtrail_events
GROUP BY sourceIPAddress
ORDER BY event_count DESC
LIMIT 20;
