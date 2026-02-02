variable "location" {
    description = "The Azure region to deploy resources in"
    type        = string
    default     = "West US"
  
}
variable "vnet-name" {
    description = "The name of the Virtual Network"
    type        = string
    default     = "himanshu-vnet-one"
  
}
