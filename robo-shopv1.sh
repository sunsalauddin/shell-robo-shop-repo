
#!/bin/bash

ami_id=ami-0eec78ea4cbaaf5bd
count=1
instance_type=t3.micro
domain_name=salauddinworks.online
hosted_zone_id=Z00524973MDJRJGQZS6DZ

for instance in "$@"
do
    echo "Creating instance : $instance"

    instance_id=$(aws ec2 run-instances \
        --image-id "$ami_id" \
        --instance-type "$instance_type" \
        --security-groups roboshop-mongodb-sg \
        --query "Instances[0].InstanceId" \
        --output text
    )

    echo "instance-id: $instance_id"

    if [ "$instance" != "frontend" ]; then

        IP=$(aws ec2 describe-instances --instance-id "$instance_id" \
            --query "Reservations[*].Instances[*].PrivateIpAddress" \
            --output text
        )

        r53_record="$instance.$domain_name"

    else

        IP=$(aws ec2 describe-instances --instance-id "$instance_id" \
            --query "Reservations[*].Instances[*].PublicIpAddress" \
            --output text
        )

        r53_record="$domain_name"

    fi

    # Updating Route 53

	echo "Record: ${R3_record}"
	aws route53 change-resource-record-sets \
        --hosted-zone-id "$hosted_zone_id" \
        --change-batch "{
            \"Comment\": \"Create a basic A record for $r53_record\",
            \"Changes\": [
                {
                    \"Action\": \"UPSERT\",
                    \"ResourceRecordSet\": {
                        \"Name\": \"$r53_record\",
                        \"Type\": \"A\",
                        \"TTL\": 1,
                        \"ResourceRecords\": [
                            {
                                \"Value\": \"$IP\"
                            }
                        ]
                    }
                }
            ]
        }"
	echo "Updated R53 record for $instance"
done
