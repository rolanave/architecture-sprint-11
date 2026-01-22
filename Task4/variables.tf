#=========== main ==============
variable "default_zone" {
  description = "The default zone"
  type        = string
  default     = "ru-central1-a"
}

#=========== network ==============
variable "network_name" {
  description = "The name of main network"
  type        = string
}

variable "int_ntwrk_cidr" {
  description = "Internal network cidr"
  type        = list(string)
}

variable "ext_ntwrk_cidr" {
  description = "External network cidr"
  type        = list(string)
}
