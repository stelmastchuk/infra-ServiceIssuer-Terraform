output "vpc_arn" {
  value = aws_vpc.this.arn
}

output "rds" {
  value = aws_db_instance.db.endpoint
}
