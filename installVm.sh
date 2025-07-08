#!/bin/bash
apt-get update && apt-get upgrade -y

echo "Baixando o arquivo do Victoria Metrics"

wget "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v1.120.0/victoria-metrics-linux-amd64-v1.120.0.tar.gz" \
    && tar -xvf victoria-metrics-linux-amd64-v1.120.0.tar.gz

echo "Inicializando o servidor VM"
./victoria-metrics-prod