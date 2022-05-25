variable "ZONE" {
    type = string
    description = "Cloud Zone"
}

variable "HOSTNAME" {
    type = string
    description = "VSI Hostname"
}

variable "RESOURCE_GROUP" {
    type = string
    description = "Resource Group"
}

# Volume sizes

locals {

VOL1 = "32"
VOL2 = "32"
VOL3 = "64"
VOL4 = "128"
VOL5 = "256"

}
