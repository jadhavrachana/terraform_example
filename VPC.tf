# VPC
resource "aws_vpc" "rachanaVPC" {
   cidr_block = "${var.vpc_cidr}"     # create the VPC
   enable_dns_hostnames=true
   tags{
       Name = "rachanaVPC"
   }
}

#IGW
resource "aws_internet_gateway" "rachanaigw" {
    vpc_id  ="${aws_vpc.rachanaVPC.id}"
         # create the igw attach to  the vpc 
        tags{
            Name= "rachanaigw"
        }
}

#Public subnet
resource "aws_subnet" "rachanapublicsubnet" {
     vpc_id  ="${aws_vpc.rachanaVPC.id}"
    count ="${length(var.public_subnet_cidr)}" 
    cidr_block="${element(var.public_subnet_cidr, count.index)}"
    availability_zone="${element(var.azs, count.index)}"
# for single subnet    availability_zone="${var.azs}"
tags{
    Name ="rachanapublicsubnet-${count.index + 1}"
}
  map_public_ip_on_launch=true   #assign the public ip automatically whenever the subnet is created 
}

#public route table
resource "aws_route_table" "rachanapublicroutetable" {
           vpc_id  ="${aws_vpc.rachanaVPC.id}"
          route {
              cidr_block = "0.0.0.0/0"
              gateway_id = "${aws_internet_gateway.rachanaigw.id}"
          }
          tags{
                Name = "rachanapublicroutetable"

          }
}

# public route table association to  public subnet

resource "aws_route_table_association" "rachanapublicroutetableassociation" {
        count ="${length(var.public_subnet_cidr)}" 
        subnet_id="${element(aws_subnet.rachanapublicsubnet.*.id, count.index)}"
        route_table_id="${aws_route_table.rachanapublicroutetable.id}"
}

#private subnet
resource "aws_subnet" "rachanaprivatesubnet" {
     vpc_id  ="${aws_vpc.rachanaVPC.id}"
    count ="${length(var.private_subnet_cidr)}" 
    cidr_block="${element(var.private_subnet_cidr, count.index)}"
    availability_zone="${element(var.azs, count.index)}"

tags{
    Name ="rachanaprivatesubnet-${count.index + 1}"
}
  
}

#private route table
resource "aws_route_table" "rachanaprivateroutetable" {
           vpc_id  ="${aws_vpc.rachanaVPC.id}"
          tags{
                Name = "rachanaprivateroutetable"

          }
}

resource "aws_route_table_association" "rachanaprivateroutetableassociation" {
        count ="${length(var.private_subnet_cidr)}" 
        subnet_id="${element(aws_subnet.rachanaprivatesubnet.*.id, count.index)}"
        route_table_id="${aws_route_table.rachanaprivateroutetable.id}"
}
   




