#!/bin/sh
set -e

echo "Waiting for MySQL..."
until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --skip-ssl -e "SELECT 1;" >/dev/null 2>&1; do
  sleep 1
done

echo "Starting backend..."
exec uvicorn app.main:app --host 0.0.0.0 --port 8000
