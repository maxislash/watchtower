#!/bin/bash

#Database creation
aws rds create-db-instance --db-name watchtower --db-instance-identifier db-watchtower --engine mariadb --db-instance-class db.t2.micro --allocated-storage 5 --master-username watchtower --master-user-password watchtower-password

aws rds wait db-instance-available --db-instance-identifier db-watchtower

echo "Mariadb database created"

#Notification
ARN=`aws sns create-topic --name itmo544 --query 'TopicArn' | cut -d\" -f2` 
aws sns subscribe --topic-arn $ARN --protocol email --notification-endpoint mdescos@iit.edu
echo "Notifcation system created with my email as endpoint"
