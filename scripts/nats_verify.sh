# Check if NATS server is running and responsive
nats server check connection

# Check JetStream status
nats server check jetstream

# Alternative: Check if server is listening
nats server info

# Test JetStream functionality
nats stream add test-stream --subjects "test.*" --storage file --replicas 1
nats pub test.hello "Hello JetStream"
nats stream info test-stream

# List streams
nats stream list

# Subscribe to test messages (optional)
nats sub test.*

# Clean up test stream when done
nats stream delete test-stream
