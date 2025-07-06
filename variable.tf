variable "ami" {
   description = "blueprint for creating ec2"
   type = string
   default = "ami-0c803b171269e2d72"
}

variable "instance_type" {
   description = "ec2 free tier"
   type = string
   default = "t3.micro"
}