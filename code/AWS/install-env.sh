#!/bin/bash

if [ $# != 6 ]
then
	echo "Not the proper amount of parameters: 6 needed : ami-id keyname securitygroup launchconfiguration count iamprofile"
else
	AMIID=$1
	KEYNAME=$2
	SECURITYGROUP=$3
	LAUNCHCONFIGURATION=$4
	COUNT=$5
	IAM=$6

	echo "DNS name of the load balancer :"
	SUBNET=`aws ec2 describe-subnets --filters "Name=availabilityZone,Values=us-west-2b" --query 'Subnets[*].SubnetId'`
	aws elb create-load-balancer --load-balancer-name watchtowerLB --listeners Protocol=Http,LoadBalancerPort=80,InstanceProtocol=Http,InstancePort=80 --subnets $SUBNET --security-groups $SECURITYGROUP

	aws autoscaling create-launch-configuration --launch-configuration-name $LAUNCHCONFIGURATION --image-id $AMIID --key-name $KEYNAME --iam-instance-profile $IAM --instance-type t2.micro --user-data file://install-app.sh  --security-groups $SECURITYGROUP

	aws autoscaling create-auto-scaling-group --auto-scaling-group-name watchtower --launch-configuration $LAUNCHCONFIGURATION --availability-zone us-west-2b --max-size 5 --min-size 0 --desired-capacity $COUNT

	aws autoscaling attach-load-balancers --auto-scaling-group-name watchtower --load-balancer-names watchtowerLB

	echo "All done"
fi
