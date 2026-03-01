#!/bin/sh

echo "Running Prisma migrate deploy..."

npx prisma migrate deploy

if [ $? -ne 0 ]; then
  echo "Migration failed. Trying resolve..."

  # ดึงชื่อ migration ล่าสุด
  LAST_MIGRATION=$(ls -t prisma/migrations | head -n 1)

  echo "Resolving $LAST_MIGRATION ..."
  npx prisma migrate resolve --applied $LAST_MIGRATION

  echo "Retrying deploy..."
  npx prisma migrate deploy
fi

echo "Starting server..."
node server.js