#!/bin/bash
    --image-id=ami-0abcdef1234567890 
    --count=1 
    --instance-type=t3.micro 
    --domain-name=salauddinworks.online
    --hosted-zone_id=Z00524973MDJRJGQZS6DZ



    for instance in $@
    do
        echo "Creating instance: $instance"

        instance_id=$(aws ec2 run-instances \
                --image-id $image-id \
                --instance-type $instance-type \
                --security-group roboshop-$instance \
                --query "Instances[0].InstanceId" \
                --output text
        )
     


    done
    