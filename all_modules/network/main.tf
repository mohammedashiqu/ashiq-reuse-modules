####################
## local variable ##
####################
locals {
  prefix = "BTF-${var.cid}-${var.env}-${var.rgc}"
}
#######################
## vpc configuration ##
#######################
resource "aws_vpc" "vpc" {
  cidr_block    = var.vpc_cidr
  tags = {
    Name        = "${local.prefix}-VPC-01"
    Region      = var.region
    Region_code = var.rgc
    Env         = var.env
    Managed_by  = var.managed_by
    Resource    = "VPC"
    Created_on  = timestamp()
  }
}
################################
##public subnet configuration ##
################################
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnet_cidr)
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.public_availability_zone[count.index]
  tags = {
    Name        = "${local.prefix}-PUB-SUB-0${count.index + 1}"
    Region      = var.region
    Region_code = var.rgc
    Env         = var.env
    Created_on  = timestamp()
    Managed_by  = var.managed_by
    Resource    = "PUB-SUB"
    Created_on  = timestamp()
  }
}
##################################
## private subnet configuration ##
##################################
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnet_cidr)
  cidr_block              = var.private_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.private_availability_zone[count.index]
  tags = {
    Name        = "${local.prefix}-PVT-SUB-0${count.index + 1}"
    Region      = var.region
    Region_code = var.rgc
    Env         = var.env
    Managed_by  = var.managed_by
    Resource    = "PVT-SUB"
    Created_on   = timestamp()
  }
}
####################################
## internet gateway configuration ##
####################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name       = "${local.prefix}-IGW-01"
    Region     = var.region
    Region_code = var.rgc
    Env        = var.env
    Managed_by = var.managed_by
    Resource   = "IGW"
    created_on = timestamp()
  }
}
##############################
## elastic ip configuration ##
##############################
resource "aws_eip" "eip" {
  vpc   = true
  tags = {
    Name        = "${local.prefix}-EIP-01"
    Region      = var.region
    Region_code = var.rgc
    Env         = var.env
    Managed_by  = var.managed_by
    Resource    = "EIP"
    Created_on  = timestamp()
  }
}
###############################
## nat gateway configuration ##
###############################
resource "aws_nat_gateway" "ngw" {
#  count         = var.nat_count
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.eip.id
  tags = {
    Name        = "${local.prefix}-NAT-01"
    Region      = var.region
    Region_code = var.rgc
    Env         = var.env
    Managed_by  = var.managed_by
    Resource    = "NAT"
    Created_on  = timestamp()
  }
}
#####################################
## pulic route table configuration ##
#####################################
resource "aws_route_table" "public_route_table" {
  count  = var.pub_route_table_count
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${local.prefix}-PUB-RT-01"
    Region      = var.region
    Region_code = var.rgc
    Env         = var.env
    Managed_by  = var.managed_by
    Resource    = "PUB-RT"
    Created_on  = timestamp()
  }
}
##################################################
## public route table association configuration ##
##################################################
resource "aws_route_table_association" "pub_sub_pub_rt_asso" {
  count          = var.public_route_table_asso_count
  route_table_id = aws_route_table.public_route_table[0].id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}
#######################################
## private route table configuration ##
#######################################
resource "aws_route_table" "private_route_table" {
  count  = var.private_route_table_count
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${local.prefix}-PVT-RT-0${count.index + 1}"
    Region      = var.region
    Region_code = var.rgc
    Env         = var.env
    Managed_by  = var.managed_by
    Resource    = "PVT-RT"
    Craeted_on  = timestamp()
  }
}
###################################################
## private route table association configuration ##
###################################################
resource "aws_route_table_association" "pvt_sub_pvt_rt_asso" {
  count          = var.private_route_table_asso_count
  route_table_id = aws_route_table.private_route_table[count.index].id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}
#############################################
## public route table routes configuration ##
#############################################
resource "aws_route" "pub_subnet_route" {
  route_table_id         = aws_route_table.public_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
##############################################
## private route table routes configuration ##
###############################################
resource "aws_route" "pvt_subnet_route" {
  count = var.pvt_route_table_route_count
  route_table_id         = aws_route_table.private_route_table[count.index].id
  nat_gateway_id         = aws_nat_gateway.ngw.id
  destination_cidr_block = "0.0.0.0/0"
}