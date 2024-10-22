# Aki eu to criando um repositório no ECR (Elastic Container Registry), que eh onde fica guardado as imagens Docker
# O nome do repositório vai ser "ecrterraformwellingtonmysql"
resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "ecrterraformwellingtonmysql"  
  image_tag_mutability = "MUTABLE"                     

  tags = {
    Name = "ECR Terraform Wellington MySQL"             
  }
}
