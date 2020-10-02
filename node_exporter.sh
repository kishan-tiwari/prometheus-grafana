# Author  : @Kishan
# Purpose : Script to setup latest node_exporter as a service in unix based operating system.

#!/bin/bash

# Enable debug if required
#set -x

# fetch latest node_exporter version
LatestVersion=$(curl  https://raw.githubusercontent.com/prometheus/node_exporter/master/VERSION 2>/dev/null)

# download and extract tar file
cd /tmp && curl -LO  https://github.com/prometheus/node_exporter/releases/download/v$LatestVersion/node_exporter-$LatestVersion.linux-amd64.tar.gz 2>/dev/null
tar -xvf node_exporter-$LatestVersion.linux-amd64.tar.gz
sudo mv node_exporter-$LatestVersion.linux-amd64/node_exporter  /usr/local/bin/

rm -rf node_exporter-$LatestVersion.linux-amd64.tar.gz node_exporter-$LatestVersion.linux-amd64

sudo useradd -rs /bin/false node_exporter

echo \
"[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Restart=on-failure
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target"  \
| sudo tee /etc/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter
