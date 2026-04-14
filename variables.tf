variable "minio_access_key" {
  type    = string
  default = "minioadmin"
}

variable "minio_secret_key" {
  type    = string
  default = "minioadmin"
}

variable "lb_name" {
  description = "load balancer name"
  type        = string
  default     = "haproxy-lb"
}

variable "lb_frontend_port" {
  description = "port du loadbalancer"
  type        = number
  default     = 8081
}

variable "web_backend_port" {
  description = "port du service web"
  type        = number
  default     = 80
}

variable "mysql_username" {
  description = "username for mysql database"
  type = string
  default = "root"
}

variable "mysql_password" {
  description = "password for mysql database"
  type = string
  default = "root_secure_password_2026"
}