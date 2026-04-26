# Complete Observability Stack with Node.js

A production-ready observability stack featuring metrics, logs, and visualization for a Node.js application.

## 🚀 Features

- **Node.js App** - Express.js with Prometheus metrics
- **Nginx Proxy** - Reverse proxy for load balancing
- **Prometheus** - Metrics collection and alerting
- **Grafana** - Beautiful dashboards and visualization
- **Loki** - Log aggregation system
- **Promtail** - Log collector for Docker containers

## 📋 Prerequisites

- Docker Engine 20.10+
- Docker Compose v2+ (or `docker compose` plugin)
- Git (for cloning)

## 🛠️ Quick Start

```bash
# Clone the repository
git clone <your-repo-url>
cd my-observability-app

# Make scripts executable
chmod +x *.sh

# Start all services
./start.sh
# OR
docker compose up -d

# Check status
./status.sh

# Generate test traffic
./generate-traffic.sh
🌐 Access Services
Service	URL	Credentials
App	http://localhost	-
Prometheus	http://localhost:9090	-
Grafana	http://localhost:3001	admin/admin
Loki	http://localhost:3100	-
📊 Architecture
text
┌─────────┐     ┌─────────┐     ┌───────────┐
│ Browser │────▶│  Nginx  │────▶│   App     │
└─────────┘     │  :80    │     │  Node.js  │
                └─────────┘     │  :3000    │
                      │         └─────┬─────┘
                      │               │ /metrics
                      │               ▼
                      │         ┌──────────┐
                      │         │Prometheus│
                      │         │  :9090   │
                      │         └─────┬────┘
                      │               │
                      │               ▼
                      │         ┌──────────┐
                      └────────▶│ Grafana  │
                                │  :3001   │
                                └──────────┘

Logs Flow: App → Docker → Promtail → Loki → Grafana
📈 Prometheus Queries
promql
# Request rate
rate(http_requests_total[1m])

# 95th percentile latency
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Error rate
sum(rate(app_errors_total[5m])) / sum(rate(http_requests_total[5m]))

# Memory usage (MB)
nodejs_heap_size_used_bytes / 1024 / 1024
📝 Loki Log Queries
logql
# All app logs
{container="app"}

# Error logs only
{container="app"} |= "error"

# JSON parsing
{container="app"} | json | line_format "{{.message}}"
🎯 API Endpoints
Endpoint	Method	Description
/	GET	Home endpoint with counter
/health	GET	Health check
/metrics	GET	Prometheus metrics
/error	GET	Simulates an error (for testing)
/slow?delay=X	GET	Simulates slow response
🔧 Management Scripts
./start.sh - Start all services

./stop.sh - Stop all services

./status.sh - Check service status

./generate-traffic.sh - Generate test traffic

📁 Project Structure
text
.
├── app/                    # Node.js application
│   ├── Dockerfile
│   ├── index.js
│   └── package.json
├── nginx/                  # Nginx proxy
│   ├── Dockerfile
│   └── nginx.conf
├── prometheus/             # Prometheus configuration
│   ├── prometheus.yml
│   ├── alerts.yml
│   └── recording_rules.yml
├── grafana/                # Grafana configuration
│   ├── Dockerfile
│   ├── dashboards/
│   │   └── app-dashboard.json
│   └── provisioning/
│       └── dashboards/
│           └── dashboard-provider.yml
├── loki/                   # Loki configuration
│   └── config.yaml
├── promtail/               # Promtail configuration
│   └── config.yaml
├── docker-compose.yml      # Service orchestration
├── start.sh                # Start script
├── stop.sh                 # Stop script
├── status.sh               # Status check
├── generate-traffic.sh     # Traffic generator
└── README.md               # This file
🛑 Stopping the Stack
bash
# Stop all services
./stop.sh
# OR
docker compose down

# Stop and remove volumes (clears data)
docker compose down -v
🔍 Troubleshooting
Check service status
bash
docker compose ps
./status.sh
View logs
bash
docker compose logs -f app
docker compose logs -f prometheus
Restart a specific service
bash
docker compose restart app
Rebuild after changes
bash
docker compose up -d --build
📊 Grafana Dashboard
The dashboard includes:

Request rate and response times

HTTP status code distribution

CPU and memory usage

Top endpoints by traffic

Recent logs

To access: http://localhost:3001 (admin/admin)

🚨 Alerting Rules
Configured alerts:

AppDown - Application unreachable for 1 minute

HighRequestRate - Request rate > 100 req/sec for 2 minutes

HighErrorRate - Error rate > 5% for 2 minutes

SlowResponses - P95 latency > 2 seconds for 3 minutes

HighMemoryUsage - Memory usage > 90% for 5 minutes

🔄 CI/CD Integration
Example GitHub Actions workflow:

yaml
name: Deploy
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to server
        run: |
          docker compose up -d --build
          ./status.sh
📝 License
MIT

🤝 Contributing
Feel free to submit issues and enhancement requests!

📧 Support
For issues, please check the troubleshooting section or open a GitHub issue.

## 🏷️ Badges

![Docker Build](https://github.com/dockrphage/my-observability-app/actions/workflows/docker-build.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Docker Compose](https://img.shields.io/badge/docker--compose-v2-blue)
![Node.js](https://img.shields.io/badge/node.js-18.x-green)
