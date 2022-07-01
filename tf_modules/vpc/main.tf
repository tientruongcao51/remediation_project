resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    # Must be enabled for EFS
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "main"
    }
}

resource "aws_subnet" "private-1a" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.0.0/19"
    availability_zone = "ap-southeast-1a"

    tags = {
        "Name"                                      = "private-ap-southeast-1a"
        "kubernetes.io/role/internal-elb"           = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
}

resource "aws_subnet" "private-1b" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = "10.0.32.0/19"
    availability_zone = "ap-southeast-1b"

    tags = {
        "Name"                                      = "private-ap-southeast-1b"
        "kubernetes.io/role/internal-elb"           = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public-1a" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.64.0/19"
    availability_zone       = "ap-southeast-1"
    map_public_ip_on_launch = true

    tags = {
        "Name"                                      = "public-ap-southeast-1a"
        "kubernetes.io/role/elb"                    = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public-1b" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.96.0/19"
    availability_zone       = "ap-southeast-1b"
    map_public_ip_on_launch = true

    tags = {
        "Name"                                      = "public-ap-southeast-1b"
        "kubernetes.io/role/elb"                    = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
}