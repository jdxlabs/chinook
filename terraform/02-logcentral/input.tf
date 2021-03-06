# =============================================================================

variable "project_name" {}
variable "project_region" {}

variable "public_key_path" {}

variable "logstore_number" {}
variable "logstore_instance_type" {
  default = "m4.xlarge"
}

variable "terrabot_all_layers_dir" {}

variable "deployment" {}

# =============================================================================

provider "aws" {
  region = "${var.project_region}"
}

# =============================================================================

data "terraform_remote_state" "landscape" {
  backend = "local"
  config {
    path = "${var.terrabot_all_layers_dir}/01-landscape/${var.deployment}.tfstate"
  }
}

data "terraform_remote_state" "rights" {
  backend = "local"
  config {
    path = "${var.terrabot_all_layers_dir}/00-access-rights/${var.deployment}.tfstate"
  }
}

data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-stretch-hvm-x86_64-gp2*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["379101102735"] # Debian Project
}
