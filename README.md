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
    terraform init -reconfigure -lock=false

# reset stage 
    terraform init -migrate-state


# corrida compilacion de plan
    windows: is --
    terraform plan -var-file=env.tfvars
    terraform plan --var-file=env-production.tfvars # production
    terraform plan -var-file=env.tfvars -refresh=true

# corrida de apply
    terraform apply -var-file=env.tfvars -auto-approve 
    terraform apply -var-file=env.tfvars -auto-approve -refresh=true
    terraform apply -var-file=env.tfvars -auto-approve -lock=false
    
    # production
    terraform apply --var-file=env-production.tfvars -auto-approve

# apply & destruye al finalizar
    terraform apply -var-file=env.tfvars -auto-approve -destroy

# destroy
    terraform destroy -var-file=env.tfvars -auto-approve -refresh=true
    terraform destroy -var-file=env.tfvars -auto-approve -lock=false

    # production
    terraform destroy --var-file=env-production.tfvars -auto-approve -refresh=true 

- https://github.com/hashicorp/terraform/issues/17599#issuecomment-373557799
# We explicitly prevent destruction using terraform. 
  lifecycle {
    prevent_destroy = true
  }

# configurar CLI de aws
aws configure


$(aws ecr get-login --region us-east-1)

aws ecr get-login-password | docker login --username AWS --region us-east-1 --password-stdin 202***551.dkr.ecr.us-east-1.amazonaws.com

docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) xxxxxxxx.dkr.ecr.us-east-1.amazonaws.com


# rol por aws y limpieza
aws iam list-instance-profiles
aws iam delete-instance-profile --instance-profile-name ec2_profile


# copiar desde terminal 
    sudo apt install xclip
xclip -selection c < ~/.ssh/terraform.pub

# generar key 
ssh-keygen -t rsa -b 4096 -C "dev@neogaleno.com"
    name: terraform

# aumentar limite en servidor
/etc/ssh/sshd_config
    MaxAuthTries 10

# reiniciar ssh
sudo systemctl restart sshd

# Limitar los métodos de autenticación en el servidor
/etc/ssh/sshd_config
    PasswordAuthentication no
    PubkeyAuthentication yes

# Revisar los logs del servidor SSH
sudo tail -f /var/log/auth.log

    en algunos sistemas (como CentOS o Amazon Linux):
    sudo tail -f /var/log/secure

# To update the locked dependency selections to match a changed configuration, run:
│   terraform init -upgrade


  # Detener y eliminar el contenedor proxy-ng si ya está corriendo
  "docker stop proxy-ng || true",   # Detiene el contenedor si existe
  "docker rm proxy-ng || true",     # Elimina el contenedor si ya existe

  # Borrado de todos los activos y limpiar todos los pausados
    docker ps -q --filter "name=$name" | xargs -r docker stop
    docker ps -aq --filter "name=$name" | xargs -r docker rm


# Pasos para Usar Workspaces
    terraform workspace new production

Si ya tienes un workspace de producción, simplemente cámbiate a él:
    
    > terraform workspace select production

Cuando aplicas Terraform, ahora operará en el workspace de producción con su propio estado separado de staging.
    
    terraform apply -var-file=env.tfvars -auto-approve -refresh=true


2. Manejar el Estado de Forma Separada (Archivos de Estado por Entorno)
```
/terraform
  /staging
    - main.tf
    - terraform.tfstate
  /production
    - main.tf
    - terraform.tfstate
```
Opción B: Backend Remoto Separado
Ejemplo de configuración de backend en staging:
```
terraform {
  backend "s3" {
    bucket = "mi-bucket-terraform"
    key    = "staging/terraform.tfstate"
    region = "us-east-1"
  }
}
```

# 3. Eliminar el Estado Local o la Caché de un Entorno (Opcional)
rm -rf terraform.tfstate* .terraform/
    windows
    Remove-Item -Recurse -Force terraform.tfstate* 
    Remove-Item -Recurse -Force .terraform/

4. Configuración de Variables Diferentes para Producción
Crea un archivo terraform.tfvars específico para producción:
    production.tfvars
    terraform apply -var-file=production.tfvars



