#!/bin/bash

ACCESS_LOG="/var/log/nginx/access.log"
ACCESS_LOG="/var/log/nginx/access-wrapper.log"
INACTIVITY_LIMIT=600 # 10 minutes

# Ensure access log file exists
touch "$ACCESS_LOG"
# Reset timestamp to now
date +%s > /tmp/last_access

# Start Nginx in the background
nginx &
NGINX_PID=$!
echo "Started Nginx with PID $NGINX_PID"

# Monitor access log updates
(
  tail -F "$ACCESS_LOG" | while read line; do
    echo "Access log updated: $line"
    # Extract the timestamp from the log line
    date +%s > /tmp/last_access
  done
) &

# Idle loop
# ps -p $NGINX_PID > /dev/null 2>&1

while true; do
    ps $NGINX_PID > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Nginx process $NGINX_PID is not running, exiting..."
        exit 1
    fi

    NOW=$(date +%s)
    LAST_ACCESS=$(cat /tmp/last_access)
    INACTIVE_FOR=$((NOW - LAST_ACCESS))

    echo "Last access $LAST_ACCESS was $INACTIVE_FOR seconds ago"

    if [ "$INACTIVE_FOR" -ge "$INACTIVITY_LIMIT" ]; then
        echo "No access in $INACTIVE_FOR seconds, stopping Nginx..."
        kill -QUIT $NGINX_PID
        wait $NGINX_PID
        exit 0
    fi

    sleep 10
done