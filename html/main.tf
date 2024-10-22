# Aki, eu to declarando o provedor da AWS e a região que vou usar, no caso a "us-east-1"
provider "aws" {
  region = "us-east-1"
}

# Criação do bucket S3. O nome é "terraform-tisaude-wellingtonaguiar-devops" e force_destroy
# significa que o bucket vai ser deletado com tudo dentro se for destruído
resource "aws_s3_bucket" "website_bucket" {
  bucket = "terraform-tisaude-wellingtonaguiar-devops"
  force_destroy = true
}

# Aki eu estou configurando o bucket para permitir acesso público, desabilitando as restrições
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.website_bucket.id
  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

# Aki estou fazendo a configuração do site no bucket S3. Definindo o arquivo principal como "index.html" e o de erro como "index.html"
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Aki é a identidade de acesso da origem do CloudFront, que vai permitir que o CloudFront acesse o conteúdo do S3
resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "OAI for my CloudFront distribution"
}

# Agora eu tô criando uma política pro bucket, permitindo que o CloudFront tenha acesso aos objetos no bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Permissão pro CloudFront acessar o S3
        Effect    = "Allow"
        Principal = {
          "AWS" = aws_cloudfront_origin_access_identity.example.iam_arn
        }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      },
      {
        # Aki estou permitindo acesso público também, então qualquer um pode pegar os objetos do S3
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

# Agora estou fazendo o upload do arquivo "index.html" pro bucket
resource "aws_s3_object" "html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}

# Mesma coisa Aki, só que com o arquivo CSS principal
resource "aws_s3_object" "css_main" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "style.css"
  source = "style.css"
  content_type = "text/css"
}

# E Aki um outro CSS, o responsivo
resource "aws_s3_object" "css_responsivo" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "responsivo.css"
  source = "responsivo.css"
  content_type = "text/css"
}

# Upload da imagem principal pro bucket
resource "aws_s3_object" "img_principal" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "principal.png"
  source = "principal.png"
  content_type = "image/png"
}

# Mesma coisa para os ícones
resource "aws_s3_object" "img_icon1" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "icon1.png"
  source = "icon1.png"
  content_type = "image/png"
}

resource "aws_s3_object" "img_icon2" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "icon2.png"
  source = "icon2.png"
  content_type = "image/png"
}

resource "aws_s3_object" "img_icon3" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "icon3.png"
  source = "icon3.png"
  content_type = "image/png"
}

# Aki tô subindo a imagem do LinkedIn
resource "aws_s3_object" "img_linkedin" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "link.png"
  source = "link.png"
  content_type = "image/png"
}

# Aki eu configuro a distribuição do CloudFront pra servir esse conteúdo do S3
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    # A origem do conteúdo é o bucket do S3
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = "S3Origin"
  }

  enabled = true

  # Configurações do cache e comportamento padrão do CloudFront
  default_cache_behavior {
    target_origin_id = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Certificado padrão da CloudFront (HTTPS)
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Sem restrições geográficas
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Arquivo principal que o CloudFront vai procurar
  default_root_object = "index.html"
}
