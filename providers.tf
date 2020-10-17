terraform {
  required_version = "~> 0.12"
  required_providers {
    local  = "~> 1.4"
    aws    = "~> 3.0"
    random = "~> 2.1"
  }
}

provider "aws" {
  region  = var.default_region
  profile = "autoid"
}

provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}
