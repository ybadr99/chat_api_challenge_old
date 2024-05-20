#!/bin/bash
set -e

# Function to wait for the database service to be ready
function wait_for_db() {
  until mysql -h "$DATABASE_HOST" -u "$DATABASE_USER" -p"$DATABASE_PASSWORD" -e 'SHOW DATABASES;' > /dev/null 2>&1; do
    echo "Waiting for database to be ready..."
    sleep 3
  done
}

# Start Redis server in the background
redis-server &

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for the database to be ready
wait_for_db

# Run database migrations
bundle exec rake db:migrate

# Seed the database
bundle exec rake db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
