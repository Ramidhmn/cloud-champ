resource "google_compute_address" "jenkins_ip" {
  name   = "instance-ip"
  region = var.region
}


resource "google_compute_instance" "jenkins_sonar_instance" {
  project = var.project_id
  name         = "jenkins-sonar-instance"
  machine_type = "n1-standard-2"  # t2-xlarge n'existe pas sur GCP, mais n1-standard-4 est similaire.
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
      nat_ip = google_compute_address.jenkins_ip.address
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y openjdk-11-jdk git curl docker.io

    # Install Jenkins
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    apt-get update
    apt-get install -y jenkins
    systemctl start jenkins
    systemctl enable jenkins

    # Install SonarQube
    apt-get install -y postgresql postgresql-contrib
    sudo -u postgres psql -c "CREATE USER sonar WITH PASSWORD 'sonar';"
    sudo -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
    sudo -u postgres psql -c "ALTER USER sonar WITH SUPERUSER;"
    wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.6.50800.zip
    unzip sonarqube-8.9.6.50800.zip -d /opt
    mv /opt/sonarqube-8.9.6.50800 /opt/sonarqube
    useradd -d /opt/sonarqube sonarqube
    chown -R sonarqube:sonarqube /opt/sonarqube
    cat <<EOF > /etc/systemd/system/sonarqube.service
    [Unit]
    Description=SonarQube service
    After=network.target network-online.target
    Wants=network-online.target

    [Service]
    Type=simple
    User=sonarqube
    Group=sonarqube
    PermissionsStartOnly=true
    ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
    ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
    StandardOutput=syslog
    LimitNOFILE=65536
    LimitNPROC=4096
    TimeoutStartSec=5
    Restart=always
    SuccessExitStatus=143

    [Install]
    WantedBy=multi-user.target
    EOF
    systemctl start sonarqube
    systemctl enable sonarqube

    # Install security tools
    # Install Trivy
    wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.20.2_Linux-64bit.deb
    dpkg -i trivy_0.20.2_Linux-64bit.deb

    # Install Snyk
    curl -sL https://snyk.io/install | bash

    # Install Houdini
    # Note: Houdini is a more complex setup and may require additional steps not covered in this simple script.
    # Ensure you replace the following URL with the correct download link.
    wget https://github.com/houdini/houdini/releases/latest/download/houdini_linux_x86_64.tar.gz
    tar -zxvf houdini_linux_x86_64.tar.gz -C /usr/local/bin

    # Docker permissions
    usermod -aG docker jenkins
    usermod -aG docker sonarqube

    # Reboot to apply all changes
    reboot
  EOT
}
