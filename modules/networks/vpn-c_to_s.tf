resource "google_compute_instance" "vpn_server" {
  name         = "vpn-server"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = google_compute_network.my_cloud_ntwrk.name
    subnetwork = google_compute_subnetwork.kube_subnet.name
       
        access_config {
        nat_ip = google_compute_address.vpn_ip_server.address
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y openvpn easy-rsa
    make-cadir /etc/openvpn/easy-rsa
    cd /etc/openvpn/easy-rsa
    ./easyrsa init-pki
    ./easyrsa build-ca nopass
    ./easyrsa gen-dh
    ./easyrsa build-server-full server nopass
    ./easyrsa build-client-full client1 nopass
    cp pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem /etc/openvpn
    gzip -c --best pki/issued/client1.crt > /etc/openvpn/client1.crt.gz
    gzip -c --best pki/private/client1.key > /etc/openvpn/client1.key.gz
    gzip -c --best pki/ca.crt > /etc/openvpn/ca.crt.gz

    cat <<EOF > /etc/openvpn/server.conf
    port 1194
    proto udp
    dev tun
    ca ca.crt
    cert server.crt
    key server.key
    dh dh.pem
    server 10.8.0.0 255.255.255.0
    ifconfig-pool-persist ipp.txt
    push "redirect-gateway def1 bypass-dhcp"
    push "dhcp-option DNS 8.8.8.8"
    push "dhcp-option DNS 8.8.4.4"
    keepalive 10 120
    cipher AES-256-CBC
    comp-lzo
    user nobody
    group nogroup
    persist-key
    persist-tun
    status openvpn-status.log
    log-append /var/log/openvpn.log
    verb 3
    EOF

    systemctl start openvpn@server
    systemctl enable openvpn@server
  EOT
}

resource "google_compute_address" "vpn_ip_server" {
  name   = "vpn-ip-server"
  region = var.region
}

output "vpn_ip" {
  value = google_compute_address.vpn_ip_server.address
}