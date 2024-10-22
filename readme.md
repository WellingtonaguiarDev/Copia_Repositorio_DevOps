# Teste de DevOps

Estamos democratizando a saúde no Brasil, somos apaixonados por inovação. Vem revolucionar o mercado da saúde com a gente!

## Desafio

O objetivo desse desafio é criar uma infra para dois sites e um banco de dados usando Terraform.

-   Um site em html deve ser hospedado em um S3

        http://terraform-tisaude-wellingtonaguiar-devops.s3-website-us-east-1.amazonaws.com/
-   Outro site deve ser hospedado dentro de uma EC2
        ![Imagem 1](imagens%20readme/ec2.png)
-   Criar um banco de dados MySQL no RDS
        ![Imagem 2](imagens%20readme/rds1.png)
        ![Imagem 3](imagens%20readme/rds2.png)

## Diferenciais

- O site em html ter vinculação com o Cloudfront
        ![Imagem 4](imagens%20readme/cloudfront.png)
- A EC2 ter regra de autoscaling e/ou spot
        ![Imagem 5](imagens%20readme/AutoScaling.png)
- O RDS e a EC2 não ter ip público.
        ![Imagem 6](imagens%20readme/ec2.png)
        ![Imagem 7](imagens%20readme/rds2.png)
- Criar ECR dos projetos
        ![Imagem 8](imagens%20readme/ecr.png)

## Observações
- Dentro de cada pasta alem dos arquivos dos sites, tem o codigo **MAIN.TF** e o **ECR.TF** contendo todo o codigo infra do terraform
- Foi feito o upload da imagem Dockerfile para o ecr do EC2
        ![Imagem 9](imagens%20readme/dockerecr.png)