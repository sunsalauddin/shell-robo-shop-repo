#!/bin/bash
    aws ec2 run-instances \
    --image-id ami-0055977a6e828a4f4 \
    --instance-type t3.micro \
    --security-groups robo-comman-sg \
    --count 1 \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=shell-robo-shop}]'
