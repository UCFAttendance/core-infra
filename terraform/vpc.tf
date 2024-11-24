locals {
  vpc_cidr_block = "192.168.0.0/20"
  public_subnets = {
    "${var.aws_region}a" = {
      ipv6 = cidrsubnet(aws_vpc.attendance_vpc.ipv6_cidr_block, 8, 1)
      ipv4 = cidrsubnet(aws_vpc.attendance_vpc.cidr_block, 4, 1)
    }
    "${var.aws_region}b" = {
      ipv6 = cidrsubnet(aws_vpc.attendance_vpc.ipv6_cidr_block, 8, 2)
      ipv4 = cidrsubnet(aws_vpc.attendance_vpc.cidr_block, 4, 2)
    }
  }
  private_subnets = {
    "${var.aws_region}a" = {
      ipv6 = cidrsubnet(aws_vpc.attendance_vpc.ipv6_cidr_block, 8, 3)
      ipv4 = cidrsubnet(aws_vpc.attendance_vpc.cidr_block, 4, 3)
    }
    "${var.aws_region}b" = {
      ipv6 = cidrsubnet(aws_vpc.attendance_vpc.ipv6_cidr_block, 8, 4)
      ipv4 = cidrsubnet(aws_vpc.attendance_vpc.cidr_block, 4, 4)
    }
  }
}

resource "aws_vpc" "attendance_vpc" {
  cidr_block                       = local.vpc_cidr_block
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "attendance-vpc"
  }
}

resource "aws_internet_gateway" "attendance_internet_gateway" {
  vpc_id = aws_vpc.attendance_vpc.id
  tags = {
    Name = "Internet Gateway IPv4"
  }
}

resource "aws_subnet" "public" {
  count           = length(local.public_subnets)
  cidr_block      = element(values(local.public_subnets), count.index).ipv4
  ipv6_cidr_block = element(values(local.public_subnets), count.index).ipv6
  vpc_id          = aws_vpc.attendance_vpc.id

  map_public_ip_on_launch = true
  availability_zone       = element(keys(local.public_subnets), count.index)

  tags = {
    Name = "Public Subnet ${element(keys(local.public_subnets), count.index)}"
  }
}

resource "aws_subnet" "private" {
  count           = length(local.private_subnets)
  cidr_block      = element(values(local.private_subnets), count.index).ipv4
  ipv6_cidr_block = element(values(local.private_subnets), count.index).ipv6
  vpc_id          = aws_vpc.attendance_vpc.id

  map_public_ip_on_launch = true
  availability_zone       = element(keys(local.private_subnets), count.index)

  tags = {
    Name = "Private Subnet ${element(keys(local.private_subnets), count.index)}"
  }
}

resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.attendance_vpc.main_route_table_id

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route" "public_internet_gateway_ipv4" {
  route_table_id         = aws_default_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.attendance_internet_gateway.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_ipv6" {
  route_table_id              = aws_default_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.attendance_internet_gateway.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_default_route_table.public.id
}

resource "aws_egress_only_internet_gateway" "egress_internet_gateway_ipv6" {
  vpc_id = aws_vpc.attendance_vpc.id

  tags = {
    "Name" = "Internet Gateway IPv6 Egress Only"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.attendance_vpc.id

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private_egress_internet_gateway_ipv6" {
  route_table_id              = aws_route_table.private.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.egress_internet_gateway_ipv6.id

  timeouts {
    create = "5m"
  }
}
