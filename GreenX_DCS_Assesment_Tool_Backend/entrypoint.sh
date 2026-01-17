#!/bin/sh
set -e

echo "Waiting for MySQL..."
until nc -z "$DB_HOST" "$DB_PORT"; do
  sleep 2
done

echo "Running migrations"
alembic upgrade head

echo "Starting backend"
exec uvicorn app.main:app --host 0.0.0.0 --port 8000
