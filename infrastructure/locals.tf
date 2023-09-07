locals {
  resource_prefix = "newlook-${var.environment}"

  tags = {
    Environment = "${var.environment}"
    Region      = "${var.location}"
  }

}
