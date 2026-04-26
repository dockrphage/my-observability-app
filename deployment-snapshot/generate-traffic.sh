#!/bin/bash

echo "Generating test traffic..."

# Normal requests
for i in {1..100}; do
  curl -s http://localhost/ > /dev/null
  echo -n "."
  sleep 0.1
done
echo ""

# Some errors
echo "Testing error endpoint..."
for i in {1..5}; do
  curl -s http://localhost/error > /dev/null
  echo -n "E"
  sleep 0.5
done
echo ""

# Some slow requests
echo "Testing slow endpoints..."
for i in 1 2 3; do
  curl -s "http://localhost/slow?delay=$i" > /dev/null &
  echo -n "S"
done
echo ""

# Different endpoints
curl -s http://localhost/health > /dev/null
curl -s http://localhost/metrics > /dev/null

echo "Traffic generation complete!"
