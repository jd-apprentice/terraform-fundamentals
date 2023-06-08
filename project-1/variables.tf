#------------------------------------------------------------------------------
# Planetscale
#------------------------------------------------------------------------------

variable "PORT" {
    description = "Port"
    type = string
    default = 4500
}

variable "HOST" {
    description = "Host"
    type = string
    sensitive = true
    default = ""
}

variable "USERNAME" {
    description = "Username"
    type = string
    sensitive = true
    default = ""
}

variable "PASSWORD" {
    description = "Password"
    type = string
    sensitive = true
    default = ""
}

variable "DATABASE" {
    description = "Database"
    type = string
    sensitive = true
    default = ""
}

#------------------------------------------------------------------------------
# Scrapper
#------------------------------------------------------------------------------

variable "MANUAL_USERNAME" {
    description = "Manual Username"
    type = string
    sensitive = true
    default = ""
}

variable "MANUAL_PASSWORD" {
    description = "Manual Password"
    type = string
    sensitive = true
    default = ""
}

#------------------------------------------------------------------------------
# Paths
#------------------------------------------------------------------------------

variable "SCRIPTS_PATH" {
    description = "Scripts Path"
    type = string
    default = "./scripts"
}

#------------------------------------------------------------------------------
# AWS
#------------------------------------------------------------------------------

variable "USER" {
    description = "AWS User"
    type = string
    sensitive = true
    default = "ubuntu"
}

variable "AWS_PUBLIC_KEY" {
    description = "AWS Public Key"
    type = string
    sensitive = true
    default = ""
}