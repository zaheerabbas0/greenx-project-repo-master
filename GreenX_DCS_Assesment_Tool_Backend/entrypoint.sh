#!/bin/sh
set -e

if [ -n "$DB_HOST" ]; then
  echo "Waiting for MySQL at $DB_HOST:$DB_PORT..."

  until nc -z "$DB_HOST" "$DB_PORT"; do
    echo "MySQL not ready yet..."
    sleep 2
  done

  echo "MySQL is ready!"
fi

#alembic upgrade head
exec uvicorn app.main:app --host 0.0.0.0 --port 8000
