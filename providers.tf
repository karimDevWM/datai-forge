terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  # utilise le démon Docker local (socket UNIX) : pas besoin de config si vous exécutez Terraform sur la machine distante
}
