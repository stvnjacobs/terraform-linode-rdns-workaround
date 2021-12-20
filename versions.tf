terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 1.24.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
  required_version = ">= 0.13"
}
