# common variable
variable "managed_by" {} #manged_entity_name
variable "cid" {} #customer_id
variable "env" {} #environment
variable "rgc" {} #region_code
variable "region" {} #region-name

# vpc and subnet variable
variable "vpc_cidr" {} # vpc_network_address
variable "public_subnet_cidr" {} # public_subnet_cidr_id
variable "public_availability_zone" {} # public_subnet_availability_zone
variable "private_subnet_cidr" {} #rivate_subnet_cidr_id
variable "private_availability_zone" {} # private_subnet_availability_zone
#variable "eip_count" {} # elastic_count_for_nat_gateway
#variable "nat_count" {} # nat_gateway_count
variable "pub_route_table_count" {} # public_route_table_count
variable "public_route_table_asso_count" {} # association_between_pub_route_table_and_pub_subnet
variable "private_route_table_count" {} # private_route_table_count
variable "private_route_table_asso_count" {} # association_between_pvt_route_table_and_pvt_subnet
variable "pub_route_table_route_count" {} # pub_route_table_count_for_number_of_iteration
variable "pvt_route_table_route_count" {} # pvt_route_table_count_for_number_of_iteration



