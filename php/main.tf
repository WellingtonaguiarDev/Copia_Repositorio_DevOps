# Aqui eu to configurando o provedor da AWS e definindo a região que quero usar
provider "aws" {
  region = "us-east-1"
}

# Agora eu to criando uma VPC (Virtual Private Cloud) pra minha aplicação PHP
resource "aws_vpc" "php_app_vpc" {
  cidr_block = "172.31.0.0/16" 
  enable_dns_support = true  
  enable_dns_hostnames = true  
  tags = {
    Name = "php-app-vpc" 
  }
}

# Em seguida, to criando uma sub-rede dentro da VPC
resource "aws_subnet" "php_app_subnet" {
  vpc_id            = aws_vpc.php_app_vpc.id  
  cidr_block        = "172.31.1.0/24"  
  availability_zone = "us-east-1a"  
  tags = {
    Name = "php-app-subnet"
  }
}

# Agora, eu vou criar um grupo de segurança pra minha aplicação
resource "aws_security_group" "php_app_sg" {
  vpc_id = aws_vpc.php_app_vpc.id  
  name    = "php-app-sg" 

  # Configurando regras de entrada (ingress)
  ingress {
    from_port   = 80 
    to_port     = 80 
    protocol    = "tcp"  
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # Configurando regras de saída (egress)
  egress {
    from_port   = 0  
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "php-app-sg" 
  }
}

# Agora eu to criando um Launch Template, que serve como modelo pra instancias EC2
resource "aws_launch_template" "php_app_lt" {
  name          = "php-app-lt" 
  image_id      = "ami-06b21ccaeff8cd686"  
  instance_type = "t2.micro"  

  # Aqui eh onde eu coloco o script que vai rodar na inicialização da instancia
  user_data = base64encode(<<-EOF
                #!/bin/bash
                yum update -y  # Atualizando os pacotes.
                yum install -y httpd php  # Instalando o servidor Apache e PHP.
                echo '<?php phpinfo(); ?>' > /var/www/html/index.php  # Criando um arquivo PHP pra testar.
                systemctl start httpd  # Iniciando o servidor Apache.
                systemctl enable httpd  # Garantindo que o Apache inicie com a instancia.
                EOF
  )

  lifecycle {
    create_before_destroy = true  
  }

  # Configurando a interface de rede da instancia
  network_interfaces {
    associate_public_ip_address = false  # Aki eu to dizendo que a instancia nao pode ter ip publico, conforme consta no desafio
    subnet_id                   = aws_subnet.php_app_subnet.id  
    security_groups             = [aws_security_group.php_app_sg.id]  
  }

  tags = {
    Name = "php-app-instance"  # Nomeando a instancia.
  }
}

# Agora eu to criando um Auto Scaling Group, que vai gerenciar a escala das instancias
resource "aws_autoscaling_group" "php_app_asg" {
  launch_template {
    id      = aws_launch_template.php_app_lt.id  
    version = "$Latest" 
  }

  vpc_zone_identifier = [aws_subnet.php_app_subnet.id]  
  min_size            = 1 
  max_size            = 3 
  desired_capacity    = 1  

  # Configurando tags para as instancias que vão ser criadas
  tag {
    key                 = "Name"
    value               = "php-app-instance"
    propagate_at_launch = true 
  }

  # Dependências explícitas para garantir que o grupo de segurança seja criado antes
  depends_on = [
    aws_security_group.php_app_sg
  ]
}
