#!/bin/sh
set -e

echo "Waiting for MySQL..."
for i in $(seq 1 30); do
  nc -z 127.0.0.1 3306 && echo "MySQL is up" && break
  echo "Still waiting for MySQL..."
  sleep 2
done

echo "Running migrations..."
alembic upgrade head || true

echo "Starting backend server..."
exec uvicorn app.main:app --host 0.0.0.0 --port 8000
