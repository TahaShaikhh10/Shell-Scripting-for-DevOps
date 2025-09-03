#!/bin/bash
# Script: k8s_resource_monitor.sh

# 1. Setup
REPORT_DIR="/var/log/k8s_reports"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
REPORT_FILE="$REPORT_DIR/k8s_report_$DATE.html"

SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXXXX/XXXXX/XXXXX"
EMAIL="admin@example.com"

# 2. Ensure directory exists
mkdir -p "$REPORT_DIR"

# 3. Start HTML report
cat <<EOF > "$REPORT_FILE"
<html>
<head><title>K8s Cluster Report - $DATE</title></head>
<body>
<h2>☸️ Kubernetes Cluster Report ($DATE)</h2>
<pre>
EOF

# 4. Cluster info
echo "🔹 Cluster Info:" >> "$REPORT_FILE"
kubectl cluster-info >> "$REPORT_FILE" 2>&1
echo "" >> "$REPORT_FILE"

# 5. Nodes status
echo "🔹 Nodes Status:" >> "$REPORT_FILE"
kubectl get nodes -o wide >> "$REPORT_FILE" 2>&1
echo "" >> "$REPORT_FILE"

# 6. Pods summary
echo "🔹 Pods in All Namespaces:" >> "$REPORT_FILE"
kubectl get pods --all-namespaces -o wide >> "$REPORT_FILE" 2>&1
echo "" >> "$REPORT_FILE"

# 7. Deployments
echo "🔹 Deployments:" >> "$REPORT_FILE"
kubectl get deployments --all-namespaces >> "$REPORT_FILE" 2>&1
echo "" >> "$REPORT_FILE"

# 8. Resource usage (needs Metrics Server installed in cluster)
echo "🔹 Resource Usage:" >> "$REPORT_FILE"
kubectl top nodes >> "$REPORT_FILE" 2>&1
kubectl top pods --all-namespaces >> "$REPORT_FILE" 2>&1
echo "" >> "$REPORT_FILE"

# 9. End HTML
cat <<EOF >> "$REPORT_FILE"
</pre>
</body>
</html>
EOF

# 10. Slack Notification
MESSAGE="☸️ New Kubernetes Cluster Report generated: $REPORT_FILE"
curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$MESSAGE\"}" \
    $SLACK_WEBHOOK_URL

# 11. Send Email with report
echo "☸️ Please find attached Kubernetes Cluster Report." | mail -s "K8s Report - $DATE" -a "$REPORT_FILE" "$EMAIL"

echo "✅ K8s report generated, saved, sent to Slack, and emailed."
