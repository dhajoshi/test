locals {
   owners = "infra-${var.prefix}/base"
   common_tags = {
     createdBy = loca.owners
  }
} 
