locals {
  tags = {
    ManagedBy = "terraform"
    Repository = var.repository
  }
}
