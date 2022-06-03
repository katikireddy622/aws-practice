# variables.tf
variable "region" {
  default = "eu-west-1"
}
variable "availabilityZone" {
  default = "eu-west-1a"
}
variable "instanceTenancy" {
  default = "default"
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "vpcCIDRblock" {
  default = "10.0.0.0/16"
}
variable "subnetCIDRblock_public" {
  default = "10.0.1.0/24"
}
variable "subnetCIDRblock_private" {
  default = "10.0.2.0/24"
}
variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "egressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "mapPublicIP" {
  default = true
}
variable "vpcName" {
  default="default VPC"
}
# end of variables.tf