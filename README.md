# terraform-aws-mock

## Crear archivo con variables necesarias
   en entorno productivo se pasan por secrets en Github Actions
   > terraform/env.tfvars
   ```
    github_user = "example@gmail.com"
    github_workspace = "tech" 
    github_repository = "some"
    github_token = "123"
    aws_region = "us-east-1"
    instance = "t2.micro"
    aws_ecr_repo_name = "algodon"
    # ubuntu oficial
    aws_ssh_user = "ubuntu"
    ami = "ami-0e86e20dae9224db8"
    AWS_ACCESS_KEY_ID = "SOME"
    AWS_SECRET_ACCESS_KEY = "SOME_SECRET"
   ```

## ir a el dir e inicializar terraform
    cd terraform/

    terraform init
        or
    terraform init -reconfigure 


# corrida compilacion de plan
    terraform plan -var-file=env.tfvars

# corrida de apply
    terraform apply -var-file=env.tfvars -auto-approve

# apply & destruye al finalizar
    terraform apply -var-file=env.tfvars -auto-approve -destroy

# destroy
    terraform destroy -var-file=env.tfvars -auto-approve


# We explicitly prevent destruction using terraform. 
  lifecycle {
    prevent_destroy = true
  }


# docker aplicado de tag a una imagen
docker tag hello-world:latest 1010101010.dkr.ecr.us-east-1.amazonaws.com/neo__

# configurar CLI de aws
aws configure

$(aws ecr get-login --region us-east-1)
aws ecr get-login-password | docker login --username AWS --password-stdin 202***551.dkr.ecr.us-east-1.amazonaws.com

docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) xxxxxxxx.dkr.ecr.us-east-1.amazonaws.com