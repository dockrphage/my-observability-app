#!/bin/bash

echo "Running containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo -e "\nTesting endpoints:"
echo -n "App: "
curl -s -o /dev/null -w "%{http_code}\n" http://localhost/

echo -n "Health: "
curl -s http://localhost/health | jq -r '.status'

echo -n "Prometheus: "
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:9090/-/healthy

echo -n "Grafana: "
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3001/api/health

echo -n "Loki: "
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3100/ready
