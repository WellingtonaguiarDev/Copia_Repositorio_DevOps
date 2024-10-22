provider "aws" {
  region = "us-east-1"  # Aki eu escolhi a região onde a infraestrutura vai ficar.
}

# Aki eu crio a VPC (Virtual Private Cloud) que vai servir como a rede privada.
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  
  tags = {
    Name = "MyVPC" 
  }
}

# Aki eu crio a Subnet Privada 1, que vai ser usada pelo RDS.
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id  
  cidr_block        = "10.0.1.0/24" 
  availability_zone = "us-east-1a"  
  tags = {
    Name = "Private Subnet 1" 
  }
}

# Aki eu crio a Subnet Privada 2, também para o RDS.
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id  
  cidr_block        = "10.0.2.0/24"  
  availability_zone = "us-east-1b"  
  tags = {
    Name = "Private Subnet 2"  
  }
}

# Aki eu crio um Grupo de Segurança para o RDS, permitindo apenas tráfego interno.
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"  
  description = "Allow MySQL traffic from within the VPC"  
  vpc_id      = aws_vpc.my_vpc.id  

  # Regras de entrada, permitindo tráfego na porta 3306 (MySQL) só da VPC.
  ingress {
    from_port   = 3306  
    to_port     = 3306  
    protocol    = "tcp"  
    cidr_blocks = ["10.0.0.0/16"]  
  }

  # Regras de saída, permitindo qualquer tráfego pra fora.
  egress {
    from_port   = 0  
    to_port     = 0  
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]  
  }

  tags = {
    Name = "RDS Security Group" 
  }
}

# Aki eu crio um Grupo de Subnet para o RDS, agrupando as subnets privadas.
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group" 
  subnet_ids = [
    aws_subnet.private_subnet_1.id,  
    aws_subnet.private_subnet_2.id   
  ]

  tags = {
    Name = "RDS Subnet Group"  
  }
}

# Aki eu crio a Instância do Banco de Dados MySQL no RDS, sem IP público.
resource "aws_db_instance" "my_mysql" {
  allocated_storage    = 20  
  engine               = "mysql"  
  engine_version       = "8.0.39"  
  instance_class       = "db.t3.micro"  
  db_name              = "terraformwellingtonaguiarmysql"  
  username             = "admin"  
  password             = "mypassword"  
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]  
  publicly_accessible  = false  # Aki eu coloco o banco de dados com ip privado, conforme consta no desafio
  skip_final_snapshot  = true  

  tags = {
    Name = "MySQL-RDS"  
  }
}
