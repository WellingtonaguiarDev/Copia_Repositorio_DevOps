# Aki eu to criando um repositório no ECR (Elastic Container Registry), que eh onde fica guardado as imagens Docker
# O nome do repositório vai ser "meu-repositorio"
resource "aws_ecr_repository" "my_repository" {
  name = "meu-repositorio"
  
  # Aki eu to configurando a mutabilidade das tags como "MUTABLE"
  # o que significa que eu posso mudar as tags das imagens depois que elas são criadas
  image_tag_mutability = "MUTABLE"
  
  # Aki eu to habilitando a varredura de imagens. Isso quer dizer que sempre que eu enviar uma nova imagem pro repositório
  # o AWS vai verificar se tem alguma vulnerabilidade nela.
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Agora eu to criando uma política de ciclo de vida para o repositório
# Essa política vai ajudar a gerenciar as imagens que estão no repositório
resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  # Aki eu to dizendo que essa política eh pra aquele repositório que acabei de criar
  repository = aws_ecr_repository.my_repository.name

  # A política eh definida Aki em JSON. Vou criar algumas regras
  policy = jsonencode({
    rules = [
      {
        # Essa eh a primeira regra, com prioridade 1
        rulePriority = 1
        description = "Expire untagged images older than 30 days"
        
        # Essa regra diz que eu vou deletar imagens que não têm tag e que foram criadas há mais de 30 dias
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
        # Essa eh a segunda regra, com prioridade 2
        rulePriority = 2
        description = "Keep the last 5 tagged images with a specific prefix"
        
        # Essa regra diz que eu vou manter as últimas 5 imagens que têm um prefixo específico
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
