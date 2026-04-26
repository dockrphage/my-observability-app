#!/bin/bash

echo "========================================="
echo "Capturing essential files for deployment"
echo "========================================="

# App files
echo -e "\n=== APP FILES ==="
echo "app/package.json"
echo "app/package-lock.json"  
echo "app/index.js"
echo "app/Dockerfile"

# Nginx files
echo -e "\n=== NGINX FILES ==="
echo "nginx/Dockerfile"
echo "nginx/nginx.conf"

# Prometheus files
echo -e "\n=== PROMETHEUS FILES ==="
echo "prometheus/prometheus.yml"
echo "prometheus/alerts.yml"
echo "prometheus/recording_rules.yml"

# Grafana files
echo -e "\n=== GRAFANA FILES ==="
echo "grafana/Dockerfile"
echo "grafana/dashboards/app-dashboard.json"
echo "grafana/provisioning/dashboards/dashboard-provider.yml"

# Loki files
echo -e "\n=== LOKI FILES ==="
echo "loki/config.yaml"

# Promtail files
echo -e "\n=== PROMTAIL FILES ==="
echo "promtail/config.yaml"

# Docker Compose
echo -e "\n=== DOCKER COMPOSE ==="
echo "docker-compose.yml"

# Scripts
echo -e "\n=== SCRIPTS ==="
echo "start.sh"
echo "stop.sh"
echo "status.sh"
echo "generate-traffic.sh"
