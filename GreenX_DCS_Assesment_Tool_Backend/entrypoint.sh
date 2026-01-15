#!/bin/sh
set -e

echo " Waiting for MySQL..."
until nc -z "$DB_HOST" "$DB_PORT"; do
  sleep 1
done
echo " MySQL ready"

echo " Running database migrations..."
#alembic upgrade head


echo " Starting application..."
exec uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 2
