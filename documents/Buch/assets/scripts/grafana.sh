#!/bin/bash

set -x

sudo -i

rm -rf /etc/netplan/*
cat <<EOF > ./10-grafana.yaml
network:
  version: 2
  ethernets:
    ens192:
      dhcp4: true
      dhcp6: false
      accept-ra: false
      link-local: [ ]
      dhcp-identifier: mac
      critical: true
    ens224:
      dhcp4: false
      dhcp6: false
      accept-ra: false
      link-local: [ ]
      addresses: ["192.168.31.100/24"]
      routes:
        - to: "default"
          via: "192.168.31.254"
EOF

netplan apply

hostnamectl hostname grafana

mkdir -p /grafana-prometheus && cd /grafana-prometheus

cat <<EOF > docker-compose.yml
version: '3.7'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - "--config.file=/etc/prometheus/prometheus.yml"

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    ports:
      - "80:3000"
    volumes:
      - grafana-storage:/var/lib/grafana
      - ./provisioning/dashboards:/etc/grafana/provisioning/dashboards
      - ./provisioning/datasources:/etc/grafana/provisioning/datasources
      - ./dashboards:/var/lib/grafana/dashboards
    depends_on:
      - prometheus

volumes:
  grafana-storage:
  prometheus-data:

EOF

mkdir -p provisioning/dashboards provisioning/datasources

cat <<EOF > provisioning/dashboards/windows.yml
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    options:
      path: /var/lib/grafana/dashboards
EOF

cat <<EOF > provisioning/datasources/datasource.yml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
EOF

cat <<EOF > prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'windows'
    static_configs:
      - targets:
        - '192.168.31.1:9182'
        - '192.168.31.2:9182'
EOF

mkdir dashboards
mv /home/administrator/Grafana_DB.json /grafana-prometheus/dashboards/

docker compose up -d

