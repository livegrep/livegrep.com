variable "region" {
  default = "us-west-2"
}
variable "account_id" {
  default = "807717602072"
}
variable "credstash_keyid" {
  default = "ba355fa9-df82-4b0a-be55-1b8f253b4947"
}
variable "ssh_keyid" {
  default = "nelhage-1"
}
variable "s3_bucket" {
  default = "livegrep"
}

variable "amis" {
    default = {
        us-west-2 = "ami-2a94444a"
    }
}
