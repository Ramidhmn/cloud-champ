resource "google_compute_address" "monitoring_ip" {
  name   = "monitoring-ip"
  region = var.region
}

resource "google_compute_instance" "monitoring_instance" {
  project = var.project_id
  name         = "monitoring-instance"
  machine_type = "n1-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network    = var.vpc_network
    subnetwork = var.jenkins_subnet

    access_config {
      nat_ip = google_compute_address.monitoring_ip.address
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io docker-compose

    # Install Prometheus
    mkdir -p /opt/prometheus
    cat <<EOF > /opt/prometheus/docker-compose.yml
    version: '3.7'
    services:
      prometheus:
        image: prom/prometheus
        container_name: prometheus
        ports:
          - "9090:9090"
        volumes:
          - prometheus_data:/prometheus
        command:
          - '--config.file=/etc/prometheus/prometheus.yml'
          - '--storage.tsdb.path=/prometheus'
          - '--web.console.libraries=/usr/share/prometheus/console_libraries'
          - '--web.console.templates=/usr/share/prometheus/consoles'
    volumes:
      prometheus_data:
    EOF

    # Install Grafana
    mkdir -p /opt/grafana
    cat <<EOF > /opt/grafana/docker-compose.yml
    version: '3.7'
    services:
      grafana:
        image: grafana/grafana
        container_name: grafana
        ports:
          - "3000:3000"
        environment:
          - GF_SECURITY_ADMIN_PASSWORD=admin
    EOF

    # Install Jaeger
    mkdir -p /opt/jaeger
    cat <<EOF > /opt/jaeger/docker-compose.yml
    version: '3.7'
    services:
      jaeger:
        image: jaegertracing/all-in-one:latest
        container_name: jaeger
        ports:
          - "6831:6831/udp"
          - "6832:6832/udp"
          - "5778:5778"
          - "16686:16686"
          - "14268:14268"
          - "14250:14250"
          - "9411:9411"
    EOF

    # Install ELK
    mkdir -p /opt/elk
    cat <<EOF > /opt/elk/docker-compose.yml
    version: '3.7'
    services:
      elasticsearch:
        image: docker.elastic.co/elasticsearch/elasticsearch:7.10.1
        container_name: elasticsearch
        environment:
          - discovery.type=single-node
        ports:
          - "9200:9200"
          - "9300:9300"
      logstash:
        image: docker.elastic.co/logstash/logstash:7.10.1
        container_name: logstash
        ports:
          - "5000:5000"
          - "9600:9600"
        volumes:
          - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
      kibana:
        image: docker.elastic.co/kibana/kibana:7.10.1
        container_name: kibana
        ports:
          - "5601:5601"
        depends_on:
          - elasticsearch
    EOF

    # Create logstash config
    mkdir -p /opt/elk
    cat <<EOF > /opt/elk/logstash.conf
    input {
      beats {
        port => 5044
      }
    }
    output {
      elasticsearch {
        hosts => ["http://elasticsearch:9200"]
      }
    }
    EOF

    # Start all services
    docker-compose -f /opt/prometheus/docker-compose.yml up -d
    docker-compose -f /opt/grafana/docker-compose.yml up -d
    docker-compose -f /opt/jaeger/docker-compose.yml up -d
    docker-compose -f /opt/elk/docker-compose.yml up -d

    # Install OpenTelemetry Collector
    mkdir -p /opt/otel
    cat <<EOF > /opt/otel/docker-compose.yml
    version: '3.7'
    services:
      otel-collector:
        image: otel/opentelemetry-collector:latest
        container_name: otel-collector
        ports:
          - "55680:55680"
          - "55681:55681"
          - "8888:8888"
        volumes:
          - ./otel-config.yaml:/etc/otel-collector-config.yaml
        command:
          - '--config=/etc/otel-collector-config.yaml'
    EOF

    # Create OpenTelemetry Collector config
    cat <<EOF > /opt/otel/otel-config.yaml
    receivers:
      otlp:
        protocols:
          grpc:
          http:
    exporters:
      logging:
      otlp:
        endpoint: "<YOUR_K8S_OTEL_ENDPOINT>:4317"
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: []
          exporters: [logging, otlp]
    EOF

    docker-compose -f /opt/otel/docker-compose.yml up -d

    # Reboot to apply all changes
    reboot
  EOT
}
