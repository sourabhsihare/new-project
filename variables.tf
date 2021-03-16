variable "region" {
  default = "ap-south-1"
}
variable "ami_id" {
    type = map
    default = {
        ap-south-1 = "ami-0d758c1134823146a"
    }
}
variable "key_name" {
   default = "terrform-demo"
}