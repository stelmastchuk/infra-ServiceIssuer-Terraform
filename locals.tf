locals {
  subnet_ids = { for k, v in aws_subnet.this : v.tags.Name => v.id }

  common_tags = {
    name  = "Projeto-Digital-Bank"
    owner = "Vitor Stelmastchuk"
  }
}


