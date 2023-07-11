#------------------------------------------------------------------------------
# AWS
#------------------------------------------------------------------------------

variable "zone" {
  description = "zone"
  type        = string
  default     = "us-east-1"
}

variable "aws_region" {
  description = "aws_region"
  type        = string
  default     = "us-east-1"
}

variable "access_key" {
  description = "access_key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "secret_key" {
  description = "secret_key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ami" {
  description = "ami"
  type        = string
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "instance_type"
  type        = string
  default     = "t2.micro"
}

variable "ssh_key" {
  description = "ssh key location"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
