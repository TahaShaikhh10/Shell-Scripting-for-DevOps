#!/bin/bash
# Script: cicd_helper.sh

# 1. Repo details
REPO_URL="https://github.com/your-username/your-project.git"
PROJECT_DIR="/home/username/myapp"

# 2. Deployment directory
DEPLOY_DIR="/var/www/myapp"

# 3. Step 1: Clone or update repo
if [ ! -d "$PROJECT_DIR" ]; then
    echo "📥 Cloning repository..."
    git clone "$REPO_URL" "$PROJECT_DIR"
else
    echo "🔄 Updating repository..."
    cd "$PROJECT_DIR" && git pull
fi

# 4. Step 2: Run tests
echo "🧪 Running tests..."
cd "$PROJECT_DIR"
if ./run_tests.sh; then
    echo "✅ Tests passed!"
else
    echo "❌ Tests failed. Deployment stopped."
    exit 1
fi

# 5. Step 3: Deploy (copy files)
echo "🚀 Deploying to $DEPLOY_DIR..."
rsync -av --delete "$PROJECT_DIR/" "$DEPLOY_DIR/"

# 6. Restart app (example: Node.js app with PM2)
echo "🔄 Restarting app..."
pm2 restart myapp || pm2 start "$DEPLOY_DIR/app.js" --name myapp

echo "🎉 Deployment completed!"
