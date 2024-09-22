    
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

# Host resource group or License Manager registered AMI example
```
resource "aws_instance" "this" {
  ami                     = "ami-0dcc1e21636832c5d"
  instance_type           = "m5.large"
  host_resource_group_arn = "arn:aws:resource-groups:us-west-2:012345678901:group/win-testhost"
  tenancy                 = "host"
}
```


# list instances in aws x86_64 arm64
aws ec2 describe-instance-types --filters Name=processor-info.supported-architecture,Values=x86_64 --query "InstanceTypes[*].InstanceType" --output text


# To accept an Elastic IP address transferred to your account
aws ec2 accept-address-transfer \
    --address 100.21.184.216

# The following code example shows how to use associate-address.
aws ec2 associate-address --instance-id i-07ffe74c7330ebf53 --public-ip 198.51.100.0

# stop 
aws ec2 stop-instances --instance-ids i-1234567890abcdef0

# terminate instances
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0

# create keypairs
aws ec2 create-key-pair --key-name MyKeyPair


# ecr login
aws ecr get-login

# create repo
aws ecr create-repository \
    --repository-name neogaleno/sample

aws ecr create-repository --repository-name front


# list images in ecr
aws ecr list-images --repository-name neogaleno
# list FOR arn: images in ecr
aws ecr list-tags-for-resource --resource-arn arn:aws:ecr:us-west-2:012345678910:repository/hello-world

# put image
aws ecr put-image \
    --repository-name sample \
    --image-tag 2024.09 \
    --image-manifest file://hello-world.manifest.json


# connect to ec2
aws ec2-instance-connect send-ssh-public-key \
    --instance-id i-1234567890abcdef0 \
    --instance-os-user ec2-user \
    --availability-zone us-east-2b \
    --ssh-public-key file://path/my-rsa-key.pub


# list users
aws iam list-users
# get account info 
aws iam get-user --user-name system

# To create an access key for an IAM user
aws iam create-access-key --user-name julio899

# create user
aws iam create-user --user-name Bob
  
  -user with a set permissions boundary
   aws iam create-user \
        --user-name Bob \
        --permissions-boundary arn:aws:iam::aws:policy/AmazonS3FullAccess

# delete User
aws iam delete-user --user-name Bob
# list-access-keys
aws iam list-access-keys --user-name system
# get-ssh-public-key
aws iam get-ssh-public-key \
    --user-name sofia \
    --ssh-public-key-id APKA123456789EXAMPLE \
    --encoding SSH