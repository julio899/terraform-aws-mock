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
    terraform plan -var-file=env.tfvars
    terraform plan -var-file=env.tfvars -refresh=true

# corrida de apply
    terraform apply -var-file=env.tfvars -auto-approve 
    terraform apply -var-file=env.tfvars -auto-approve -refresh=true
    terraform apply -var-file=env.tfvars -auto-approve -lock=false

# apply & destruye al finalizar
    terraform apply -var-file=env.tfvars -auto-approve -destroy

# destroy
    terraform destroy -var-file=env.tfvars -auto-approve -refresh=true
    terraform destroy -var-file=env.tfvars -auto-approve -lock=false


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

# Revisar los logs del servidor SSH
sudo tail -f /var/log/auth.log

    en algunos sistemas (como CentOS o Amazon Linux):
    sudo tail -f /var/log/secure

cat ~/.ssh/terraform.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxjevFLSfchk1DLmboGDMuyWduYL/YA5WDv23ePhZ5aMHTdF/hMp2X2Kfb8ggipEPp3B4hvuI8fijFlXOl89EL/MMKXnSRj5TT0SWinRHUTVzlbsAZNwfPiegzdIi3r4PswghQ5k+c81qQ5gUu60Xac1PEAJyaNe5js4TPdNenCCPpQOFLaEY2Ct7Sp5BbspO7ALTQP5/F6b2Uz2BxvIFCX+8/35MWFtkBgjsEDe1VbxQKLxpX9guJs5mQxvKQ12vBrsVYiPbJ8sLgfqU9HUXwp5BgdOgDPoRG7cv0oFoySrkuQB5NJoNA+2XDPGkKY0eAn4kpAe2XUKG6Neh9P53Oq23H8etjD4ksuw964lquqWM9tz4Y0GC5RmP9xbyz+MINSVCWo8WWsLKPtySAXaBkYd3FZzBJ35SohEt1rOeyluWTNxAGQH6f7N4gvcZmdEwUdUNKViiJW3GjqcG+UjdZIXmeiLrBQ4mCv75HYwl9UIdAXU+m/HFhVEuc4ZdLwmG3WbQFd8VobZvjFqykH4T2ESae9jQXhzeM9pJa9GP4hOL/v+fXckbNxXX0YUozRu/e5pklSXH4b2uV8Az7D6mUJspqqgnePcMA637cMarbsxmSp60Yl0VoXBZfKCpnFs+Dx2Z/7M3mZz+p3+0WCQ7EFcVtaW1a60VbOQ0ySw0Yjw== dev@neogaleno.com

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxjevFLSfchk1DLmboGDMuyWduYL/YA5WDv23ePhZ5aMHTdF/hMp2X2Kfb8ggipEPp3B4hvuI8fijFlXOl89EL/MMKXnSRj5TT0SWinRHUTVzlbsAZNwfPiegzdIi3r4PswghQ5k+c81qQ5gUu60Xac1PEAJyaNe5js4TPdNenCCPpQOFLaEY2Ct7Sp5BbspO7ALTQP5/F6b2Uz2BxvIFCX+8/35MWFtkBgjsEDe1VbxQKLxpX9guJs5mQxvKQ12vBrsVYiPbJ8sLgfqU9HUXwp5BgdOgDPoRG7cv0oFoySrkuQB5NJoNA+2XDPGkKY0eAn4kpAe2XUKG6Neh9P53Oq23H8etjD4ksuw964lquqWM9tz4Y0GC5RmP9xbyz+MINSVCWo8WWsLKPtySAXaBkYd3FZzBJ35SohEt1rOeyluWTNxAGQH6f7N4gvcZmdEwUdUNKViiJW3GjqcG+UjdZIXmeiLrBQ4mCv75HYwl9UIdAXU+m/HFhVEuc4ZdLwmG3WbQFd8VobZvjFqykH4T2ESae9jQXhzeM9pJa9GP4hOL/v+fXckbNxXX0YUozRu/e5pklSXH4b2uV8Az7D6mUJspqqgnePcMA637cMarbsxmSp60Yl0VoXBZfKCpnFs+Dx2Z/7M3mZz+p3+0WCQ7EFcVtaW1a60VbOQ0ySw0Yjw== dev@neogaleno.com" >> ~/.ssh/authorized_keys
