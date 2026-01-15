#!/bin/sh
set -e

echo "🚀 Entrypoint started"

# Wait for MySQL
if [ -n "$DB_HOST" ]; then
  echo "⏳ Waiting for MySQL..."
  until nc -z "$DB_HOST" "$DB_PORT"; do
    sleep 0.5
  done
  echo "✅ MySQL started"
fi

echo "🔍 Checking Alembic state..."

# Check if alembic_version table exists
ALEMBIC_TABLE_EXISTS=$(mysql \
  -h"$DB_HOST" \
  -u"$DB_USER" \
  -p"$DB_PASSWORD" \
  "$DB_NAME" \
  -N -e "
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema='$DB_NAME'
    AND table_name='alembic_version';
  ")

if [ "$ALEMBIC_TABLE_EXISTS" -eq 0 ]; then
  echo "⚠️ Alembic not initialized — stamping baseline"
  alembic stamp head
else
  echo "✅ Alembic already initialized"
fi

echo "📦 Running migrations"
alembic upgrade head

echo "🎯 Starting application"
exec uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 2
