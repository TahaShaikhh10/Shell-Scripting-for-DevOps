#!/bin/bash
# Script: aws_instance_manager.sh

# 1. Config
AWS_REGION="us-east-1"
INSTANCE_IDS=("i-0123456789abcdef0" "i-0abcdef1234567890")  # Replace with your instances
ACTION=$1   # start | stop | status

# 2. Function: Start instances
start_instances() {
    echo "🚀 Starting instances: ${INSTANCE_IDS[*]}"
    aws ec2 start-instances --instance-ids "${INSTANCE_IDS[@]}" --region $AWS_REGION
}

# 3. Function: Stop instances
stop_instances() {
    echo "🛑 Stopping instances: ${INSTANCE_IDS[*]}"
    aws ec2 stop-instances --instance-ids "${INSTANCE_IDS[@]}" --region $AWS_REGION
}

# 4. Function: Check status
status_instances() {
    echo "📊 Checking status of instances: ${INSTANCE_IDS[*]}"
    aws ec2 describe-instances --instance-ids "${INSTANCE_IDS[@]}" --region $AWS_REGION \
        --query "Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress]" \
        --output table
}

# 5. Main logic
case "$ACTION" in
    start)
        start_instances
        ;;
    stop)
        stop_instances
        ;;
    status)
        status_instances
        ;;
    *)
        echo "❌ Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac
