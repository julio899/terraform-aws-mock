#!/bin/bash
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
curl http://169.254.169.254/latest/meta-data/profile -H "X-aws-ec2-metadata-token: $TOKEN"


curl http://169.254.169.254/latest/meta-data/ -H "X-aws-ec2-metadata-token: $TOKEN"

# aws ec2 describe-instances \
#     --instance-id i-1234567898abcdef0 \
#     --query 'Reservations[].Instances[].MetadataOptions'

curl http://169.254.169.254/latest/meta-data/ami-id -H "X-aws-ec2-metadata-token: $TOKEN"
curl http://169.254.169.254/latest/meta-data/instance-id -H "X-aws-ec2-metadata-token: $TOKEN"
curl http://169.254.169.254/latest/meta-data/local-ipv4 -H "X-aws-ec2-metadata-token: $TOKEN"
curl http://169.254.169.254/latest/meta-data/public-ipv4 -H "X-aws-ec2-metadata-token: $TOKEN"

curl http://169.254.169.254/latest/meta-data/hostname -H "X-aws-ec2-metadata-token: $TOKEN"
curl http://169.254.169.254/latest/meta-data/public-hostname -H "X-aws-ec2-metadata-token: $TOKEN"
curl http://169.254.169.254/latest/meta-data/events/maintenance/history -H "X-aws-ec2-metadata-token: $TOKEN"
curl http://169.254.169.254/latest/meta-data/reservation-id -H "X-aws-ec2-metadata-token: $TOKEN"
curl http://169.254.169.254/latest/meta-data/instance-action -H "X-aws-ec2-metadata-token: $TOKEN"

curl http://169.254.169.254/latest/dynamic/instance-identity/document -H "X-aws-ec2-metadata-token: $TOKEN"
# accountId : 202533523551

# ami-id
# ami-launch-index
# ami-manifest-path
# block-device-mapping/
# events/
# hibernation/
# hostname
# iam/
# identity-credentials/
# instance-action
# instance-id
# instance-life-cycle
# instance-type
# local-hostname
# local-ipv4
# mac
# metrics/
# network/
# placement/
# profile
# public-hostname
# public-ipv4
# public-keys/
# reservation-id
# security-groups
# services/