#!/bin/bash

echo "Stopping all services..."
docker stop app proxy prometheus grafana loki promtail 2>/dev/null
docker rm app proxy prometheus grafana loki promtail 2>/dev/null
echo "All services stopped!"
