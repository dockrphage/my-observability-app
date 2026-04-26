const express = require('express');
const client = require('prom-client');
const app = express();
const port = process.env.PORT || 3000;

// Enable default metrics (CPU, memory, event loop, etc)
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics({ 
  timeout: 5000,
  gcDurationBuckets: [0.001, 0.01, 0.1, 1, 2, 5],
});

// Create custom metrics
const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

const httpRequestDurationSeconds = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10]
});

const activeRequests = new client.Gauge({
  name: 'http_active_requests',
  help: 'Number of active HTTP requests'
});

const errorCounter = new client.Counter({
  name: 'app_errors_total',
  help: 'Total number of application errors',
  labelNames: ['type']
});

// Application metrics
let requestCount = 0;
let customCounter = new client.Counter({
  name: 'app_custom_events_total',
  help: 'Total number of custom events',
  labelNames: ['event_type']
});

// Middleware to track metrics
app.use((req, res, next) => {
  const start = Date.now();
  activeRequests.inc();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    const status_code = res.statusCode.toString();
    const route = req.route?.path || req.path;
    
    httpRequestsTotal.inc({
      method: req.method,
      route: route,
      status_code: status_code
    });
    
    httpRequestDurationSeconds.observe({
      method: req.method,
      route: route,
      status_code: status_code
    }, duration);
    
    activeRequests.dec();
    
    // Log slow requests
    if (duration > 1) {
      console.log(`Slow request: ${req.method} ${route} took ${duration}s`);
      customCounter.inc({ event_type: 'slow_request' });
    }
  });
  
  next();
});

// Home endpoint
app.get('/', (req, res) => {
  requestCount++;
  customCounter.inc({ event_type: 'home_visit' });
  
  res.json({
    message: 'Hello from My App!',
    requestNumber: requestCount,
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Health endpoint with detailed checks
app.get('/health', async (req, res) => {
  const health = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    checks: {
      app: true,
      redis: true,  // Add actual checks if you have dependencies
      database: true
    }
  };
  res.json(health);
});

// Simulate error endpoint (for testing alerts)
app.get('/error', (req, res) => {
  errorCounter.inc({ type: 'simulated' });
  throw new Error('Simulated error for testing');
});

// Simulate slow endpoint
app.get('/slow', async (req, res) => {
  const delay = req.query.delay || 2;
  await new Promise(resolve => setTimeout(resolve, delay * 1000));
  res.json({ message: `Delayed for ${delay} seconds` });
});

// Metrics endpoint for Prometheus
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

// Error handling middleware
app.use((err, req, res, next) => {
  errorCounter.inc({ type: err.name || 'unknown' });
  console.error('Error:', err.message);
  res.status(500).json({ 
    error: 'Internal Server Error',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

app.listen(port, () => {
  console.log(`App running on port ${port}`);
  console.log(`Metrics available at http://localhost:${port}/metrics`);
  console.log(`Test endpoints: /, /health, /error, /slow?delay=3`);
});
