# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable nats-server
sudo systemctl start nats-server

# Check status
sudo systemctl status nats-server

# View logs
sudo journalctl -u nats-server -f
