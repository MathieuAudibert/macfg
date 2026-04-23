set -euo pipefail

echo "Macfg status"

if docker ps --format '{{.Names}}' 2>/dev/null | grep -q 'macfg'; then
    echo "✅ App Container: Running (http://localhost:8000)"
else
    echo "⚠️ App Container: Not running"
    echo "   Start: docker-compose up -d or /docker-up"
fi