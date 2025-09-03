#!/bin/bash


# 1. Log file to monitor
LOG_FILE="/var/log/syslog"

# 2. Word to search
KEYWORD=("ERROR" "CRITICAL" "WARNING")

# 3. File where we’ll save alerts
ALERT_FILE="/tmp/log_alerts.txt"

# 4. Check last 50 lines for keyword
ERRORS=$(tail -n 50 "$LOG_FILE" | grep "$KEYWORD")

# 5. If errors found, save them to ALERT_FILE
if [ -n "$ERRORS" ]; then
    echo "🚨 $(date): Found errors in $LOG_FILE" >> "$ALERT_FILE"
    echo "$ERRORS" >> "$ALERT_FILE"
    echo "Saved errors to $ALERT_FILE"
else
    echo "✅ No errors found."
fi
