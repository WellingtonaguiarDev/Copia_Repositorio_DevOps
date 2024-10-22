# Aqui eu to criando um repositório no ECR (Elastic Container Registry), que eh onde fica guardado as imagens Docker
# O nome do repositório vai ser "meu-repositorio1"
resource "aws_ecr_repository" "my_repository" {
  name                  = "meu-repositorio1"  
  image_tag_mutability  = "MUTABLE"          
  
  # Configurando a varredura de segurança das imagens
  image_scanning_configuration {
    scan_on_push = true 
  }
}

# Agora eu to criando uma política de ciclo de vida pra gerenciar as imagens do repositório ECR
resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.my_repository.name 

  # Definindo as regras da política de ciclo de vida em formato JSON
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1  
        description  = "Expire untagged images older than 30 days" 
        selection = {
          tagStatus   = "untagged"  
          countType   = "sinceImagePushed" 
          countUnit   = "days"  
          countNumber = 30 
        }
        action = {
          type = "expire"  
        }
      },
      {
        rulePriority = 2  
        description  = "Keep the last 5 tagged images with a specific prefix" 
        selection = {
          tagStatus       = "tagged" 
          tagPrefixList   = ["v1.", "v2."]  
          countType       = "imageCountMoreThan" 
          countNumber     = 5  
        }
        action = {
          type = "expire" 
        }
      }
    ]
  })
}
