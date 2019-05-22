#Security Group
resource "aws_security_group" "rachanalbsg" {
     name ="rachanalbsg"
     vpc_id ="${aws_vpc.rachanaVPC.id}"

     #Inbound
        ingress{
            from_port = 80
            to_port = 80
            protocol ="tcp"
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

resource "aws_elb" "rachanaelb" {
    name="rachanaelb"
    subnets =["${aws_subnet.rachanapublicsubnet.*.id}"]
    security_groups=["${aws_security_group.rachanalbsg.id}"]
    listener {
           instance_port = 80
           instance_protocol = "http"
           lb_port = 80
           lb_protocol = "http"
    }
    health_check =[{
        target ="HTTP:80/"
        interval = 30
        healthy_threshold =2
        unhealthy_threshold =2
        timeout = 5
    }]
}

