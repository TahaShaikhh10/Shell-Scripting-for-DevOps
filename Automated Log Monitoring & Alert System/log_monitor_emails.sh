#!/bin/bash
# Script: log_monitor.sh

# 1. Log file to monitor
LOG_FILE="/var/log/syslog"

# 2. Word to search
KEYWORD=("ERROR" "CRITICAL" "WARNING")

# 3. Where to save alerts (for history)
ALERT_FILE="/tmp/log_alerts.txt"

# 4. Your email address
EMAIL="you@example.com"

# 5. Check last 50 lines for keyword
ERRORS=$(tail -n 50 "$LOG_FILE" | grep "$KEYWORD")

# 6. If errors found → save to file + send email
if [ -n "$ERRORS" ]; then
    # Save to file
    echo "🚨 $(date): Found errors in $LOG_FILE" >> "$ALERT_FILE"
    echo "$ERRORS" >> "$ALERT_FILE"

    # Send email
    echo -e "🚨 Log Alert: Found errors in $LOG_FILE\n$ERRORS" | mail -s "Log Alert" "$EMAIL"

    echo "Alert sent to $EMAIL and saved in $ALERT_FILE"
else
    echo "✅ No errors found."
fi
