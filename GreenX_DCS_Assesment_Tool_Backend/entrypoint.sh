#!/bin/sh
set -e

echo "Waiting for MySQL..."
until nc -z "$DB_HOST" "$DB_PORT"; do
  sleep 1
done
echo "MySQL ready"

if [ "$#" -gt 0 ]; then
  echo "Running custom command: $@"
  exec "$@"
fi

echo "Starting application..."
exec uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 2
