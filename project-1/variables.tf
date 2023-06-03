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