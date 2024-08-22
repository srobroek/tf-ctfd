

variable "region" {
type = string

}

variable "app_name" {
  type = string
  default = "ctfd"
}

variable "frontend_desired_count" {
  type = number
  default = 3
}

variable "domain_zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}