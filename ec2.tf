# to launch the ec2
resource "aws_security_group" "rachanawssg" {
    name = "rachanawssg"
    vpc_id ="${aws_vpc.rachanaVPC.id}"
   

    #Inbound
    # SSH access from anywhere
        ingress{
            from_port = 22
            to_port = 22
            protocol ="tcp"
            cidr_blocks =["0.0.0.0/0"]
        }

        ingress{
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks =["0.0.0.0/0"]
        }


    #Outbound
        egress{
            from_port = 0
            to_port = 0
            protocol = -1
            cidr_blocks =["0.0.0.0/0"]
        }
}

resource "aws_instance" "rachanawebserver" {
        ami="${lookup(var.ami_id, var.aws_region)}"
        associate_public_ip_address= true
        instance_type ="t2.micro"
        user_data="${file("install_apache.sh")}"
        tags{
            Name="rachanawebserver"
        }
        subnet_id ="${aws_subnet.rachanapublicsubnet.*.id[0]}"
        vpc_security_group_ids=["${aws_security_group.rachanawssg.id}"]
}

resource "aws_instance" "rachanawebserver2" {
        ami="${lookup(var.ami_id, var.aws_region)}"
        associate_public_ip_address= true
        instance_type ="t2.micro"
        user_data="${file("install_apache.sh")}"
        tags{
            Name="rachanawebserver2"
        }
        subnet_id ="${aws_subnet.rachanapublicsubnet.*.id[1]}"
        vpc_security_group_ids=["${aws_security_group.rachanawssg.id}"]
}