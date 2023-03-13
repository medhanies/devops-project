terraform {
  cloud {
    organization = "medops"

    workspaces {
      name = "terransible"
    }
  }
}