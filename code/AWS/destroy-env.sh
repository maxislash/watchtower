#!/bin/bash

GROUPNAME=`aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].AutoScalingGroupName'`
echo "Autoscaling group name: " $GROUPNAME
LOADBALANCERNAME=`aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].LoadBalancerNames'`
echo "Loadbalancer name: " $LOADBALANCERNAME
CONFIGURATIONNAME=`aws autoscaling describe-launch-configurations --query 'LaunchConfigurations[*].LaunchConfigurationName'`
echo "Launch configuration name: " $CONFIGURATIONNAME
ID=`aws autoscaling describe-auto-scaling-instances --query 'AutoScalingInstances[].InstanceId'`
echo "Ids of instances on the autocaling group: " $ID
PORT=`aws elb describe-load-balancers --load-balancer-names $LOADBALANCERNAME --query 'LoadBalancerDescriptions[*].ListenerDescriptions[*].Listener[].LoadBalancerPort'`
echo "Listener port of the load balancer: " $PORT

aws autoscaling update-auto-scaling-group --auto-scaling-group-name $GROUPNAME --launch-configuration-name $CONFIGURATIONNAME --min-size 0 --max-size 0 --desired-capacity 0
aws autoscaling detach-load-balancers --auto-scaling-group-name $GROUPNAME --load-balancer-names $LOADBALANCERNAME


echo "Wait for instances to be terminated"
aws ec2 wait instance-terminated --instance-ids $ID

sleep 10
aws elb delete-load-balancer-listeners --load-balancer-name $LOADBALANCERNAME --load-balancer-ports $PORT
aws elb  delete-load-balancer --load-balancer-name $LOADBALANCERNAME

sleep 10
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $GROUPNAME

aws autoscaling delete-launch-configuration --launch-configuration-name $CONFIGURATIONNAME

aws rds delete-db-instance --db-instance-identifier db-watchtower --skip-final-snapshot

aws rds wait db-instance-deleted --db-instance-identifier db-watchtower
echo "All done"
