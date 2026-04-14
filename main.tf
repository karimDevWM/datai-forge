locals {
  haproxy_config = <<-EOT
    global
      daemon
      maxconn 256

    defaults
      mode http
      timeout connect 5s
      timeout client 50s
      timeout server 50s

    frontend http_front
      bind *:80
      default_backend http_back

    backend http_back
      server web1 tutorial:${var.web_backend_port} check
  EOT
}

// Shared Docker network used by the application containers.
resource "docker_network" "minio_net" {
  name = "minio_network"
}

// Shared Docker network used by the application containers.
resource "docker_network" "mysql_net" {
  name = "mysql_network"
}

// Persistent storage for MinIO data.
resource "docker_volume" "minio_data" {
  name = "minio_data"
}

// Persistent storage for MySQL database.
resource "docker_volume" "mysql_data" {
  name = "mysql_data"
}

// Container images used by the stack.
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_image" "minio" {
  name         = "minio/minio:latest"
  keep_locally = false
}

resource "docker_image" "mysql" {
  name         = "mysql:8.0"
  keep_locally = false
}

resource "docker_image" "haproxy" {
  name         = "haproxy:2.9"
  keep_locally = false
}

// Nginx app container exposed on port 8000.
resource "docker_container" "nginx" {
  name  = "tutorial"
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.minio_net.name
  }

  ports {
    internal = 80
    external = 8000
  }
}

// MinIO object storage container exposed on port 9000.
resource "docker_container" "minio" {
  name    = "minio-server"
  image   = docker_image.minio.image_id
  restart = "unless-stopped"

  env = [
    "MINIO_ROOT_USER=${var.minio_access_key}",
    "MINIO_ROOT_PASSWORD=${var.minio_secret_key}"
  ]

  ports {
    internal = 9000
    external = 9000
  }

  volumes {
    volume_name    = docker_volume.minio_data.name
    container_path = "/data"
  }

  command = ["server", "/data"]

  networks_advanced {
    name = docker_network.minio_net.name
  }
}

// HAProxy load balancer that forwards traffic to the Nginx container.
resource "docker_container" "haproxy" {
  name       = var.lb_name
  image      = docker_image.haproxy.image_id
  restart    = "unless-stopped"
  depends_on = [docker_container.nginx]

  networks_advanced {
    name = docker_network.minio_net.name
  }

  ports {
    internal = 80
    external = var.lb_frontend_port
  }

  upload {
    content = local.haproxy_config
    file    = "/usr/local/etc/haproxy/haproxy.cfg"
  }
}

// MySQL database storage container exposed on port 3306
resource "docker_container" "mysql" {
  name    = "mysql"
  image   = docker_image.mysql.image_id
  restart = "unless-stopped"

  env = [
    "MYSQL_USER=${var.mysql_username}",
    "MINIO_ROOT_PASSWORD=${var.mysql_password}"
  ]

  ports {
    internal = 3306
    external = 3306
  }

  volumes {
    volume_name    = docker_volume.mysql_data.name
    container_path = "/data_mysql"
  }

  command = ["server", "/data_mysql"]

  networks_advanced {
    name = docker_network.mysql_net.name
  }
}