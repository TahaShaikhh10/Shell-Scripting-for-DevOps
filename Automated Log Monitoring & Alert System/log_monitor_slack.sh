#!/bin/bash
# Script: log_monitor.sh

# 1. Log file to monitor
LOG_FILE="/var/log/syslog"

# 2. Word to search
KEYWORD="ERROR"

# 3. Slack webhook URL (replace with your own)
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXXXX/XXXXX/XXXXX"

# 4. Check last 50 lines for keyword
ERRORS=$(tail -n 50 "$LOG_FILE" | grep "$KEYWORD")

# 5. If errors found → send to Slack
if [ -n "$ERRORS" ]; then
    MESSAGE="🚨 Log Alert: Found errors in $LOG_FILE
$ERRORS"

    curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$MESSAGE\"}" \
    $SLACK_WEBHOOK_URL

    echo "Alert sent to Slack ✅"
else
    echo "✅ No errors found."
fi
