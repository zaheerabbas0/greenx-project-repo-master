#!/bin/sh
set -e

echo "Waiting for MySQL..."
until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --skip-ssl -e "SELECT 1;" >/dev/null 2>&1; do
  sleep 1
done
echo "MySQL is ready"

# Check alembic_version table ONLY
ALEMBIC_EXISTS=$(mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --skip-ssl "$DB_NAME" \
  -N -s -e "SHOW TABLES LIKE 'alembic_version';")

if [ -z "$ALEMBIC_EXISTS" ]; then
  echo "Alembic history missing → stamping head"
  alembic stamp head
else
  echo "Alembic history exists → upgrading if needed"
  alembic upgrade head
fi

echo "Starting backend server..."
exec uvicorn app.main:app --host 0.0.0.0 --port 8000
