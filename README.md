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

# destroy
    terraform destroy -var-file=env.tfvars -auto-approve