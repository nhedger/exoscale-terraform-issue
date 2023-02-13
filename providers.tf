
terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "0.45.0"
    }
  }
}

provider "exoscale" {
  key    = var.exoscale_api_key
  secret = var.exoscale_api_secret
}
