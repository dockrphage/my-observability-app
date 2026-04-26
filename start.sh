#!/bin/bash

echo "Starting all services..."

# Create network if doesn't exist
docker network inspect my-network >/dev/null 2>&1 || docker network create my-network

# Start app
docker run -d --name app --network my-network -p 3000:3000 -e PORT=3000 my-app

# Start proxy
docker run -d --name proxy --network my-network -p 80:80 my-proxy

# Start Prometheus
docker run -d --name prometheus --network my-network -p 9090:9090 \
  -v $(pwd)/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
  -v prometheus-data:/prometheus \
  prom/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus

# Start Grafana
docker run -d --name grafana --network my-network -p 3001:3000 \
  -e GF_SECURITY_ADMIN_PASSWORD=admin \
  -e GF_AUTH_ANONYMOUS_ENABLED=true \
  -v grafana-data:/var/lib/grafana \
  my-grafana

# Start Loki
docker run -d --name loki --network my-network -p 3100:3100 \
  -v $(pwd)/loki/loki-config.yaml:/etc/loki/config.yaml \
  -v loki-data:/loki \
  grafana/loki:latest -config.file=/etc/loki/config.yaml

# Start Promtail
docker run -d --name promtail --network my-network \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/containers:/var/lib/docker/containers:ro \
  -v $(pwd)/promtail/promtail-config.yaml:/etc/promtail/config.yaml \
  grafana/promtail:latest -config.file=/etc/promtail/config.yaml

echo "All services started!"
echo "App: http://localhost"
echo "Prometheus: http://localhost:9090"
echo "Grafana: http://localhost:3001 (admin/admin)"
echo "Loki: http://localhost:3100"
