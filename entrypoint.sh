#!/bin/bash
set -e

# PIDファイル残り対策
rm -f /app/tmp/pids/server.pid

exec "$@"
