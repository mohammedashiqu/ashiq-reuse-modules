output "vpc_id" {
  # this_will_output_vpc_id
  value = aws_vpc.vpc.id
}
output "pub_subnet_id" {
  # this_will_output_public_subnet_id
  value = aws_subnet.public_subnet.*.id
}
output "pvt_subnet_id" {
  # this_will_output_private_subnet_id
  value = aws_subnet.private_subnet.*.id
}