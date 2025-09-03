#!/bin/bash
# Script: system_health_cloud.sh

# 1. Setup
REPORT_DIR="/var/log/health_reports"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
REPORT_FILE="$REPORT_DIR/health_report_$DATE.html"

# Replace with your own email, Slack webhook, and S3 bucket
EMAIL="admin@example.com"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXXXX/XXXXX/XXXXX"
S3_BUCKET="my-system-health-reports"

# 2. Make report directory
mkdir -p "$REPORT_DIR"

# 3. Start HTML file
cat <<EOF > "$REPORT_FILE"
<html>
<head><title>System Health Report - $DATE</title></head>
<body>
<h2>🚀 System Health Report ($DATE)</h2>
<pre>
EOF

# 4. CPU usage
echo "🔹 CPU Load:" >> "$REPORT_FILE"
uptime >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 5. Memory usage
echo "🔹 Memory Usage:" >> "$REPORT_FILE"
free -h >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 6. Disk usage
echo "🔹 Disk Usage:" >> "$REPORT_FILE"
df -h >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 7. Services check
echo "🔹 Service Status:" >> "$REPORT_FILE"
for service in nginx mysql; do
    if systemctl is-active --quiet $service; then
        echo "✅ $service is running" >> "$REPORT_FILE"
    else
        echo "❌ $service is NOT running" >> "$REPORT_FILE"
    fi
done
echo "" >> "$REPORT_FILE"

# 8. Network check
echo "🔹 Network Check:" >> "$REPORT_FILE"
if ping -c 2 8.8.8.8 > /dev/null; then
    echo "✅ Internet is working" >> "$REPORT_FILE"
else
    echo "❌ No internet connection" >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# 9. End HTML
cat <<EOF >> "$REPORT_FILE"
</pre>
</body>
</html>
EOF

# 10. Send Slack alert
MESSAGE="📊 New System Health Report generated: $REPORT_FILE"
curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$MESSAGE\"}" \
    $SLACK_WEBHOOK_URL

# 11. Send email with attachment
echo "📊 Please find the attached system health report." | mail -s "System Health Report - $DATE" -a "$REPORT_FILE" "$EMAIL"

# 12. Upload to AWS S3
aws s3 cp "$REPORT_FILE" "s3://$S3_BUCKET/" --acl private

echo "✅ Report saved at $REPORT_FILE, sent to Slack, emailed to $EMAIL, and uploaded to S3 bucket: $S3_BUCKET"
