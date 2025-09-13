SELECT
  errorMessage,
  COUNT(*) AS occurrences
FROM cloudtrail_logs.cloudtrail_events
WHERE errorMessage IS NOT NULL
GROUP BY errorMessage
ORDER BY occurrences DESC
LIMIT 20;
