# About

This is a terraform module that provisions security groups meant to restrict network access to a cluster of alertmanager servers.

The following security group is created:
- **member**: Security group for the alertmanager cluster. It can make external requests and communicate with other members of the **member** group on ports **9093** (alertmanager client port) and **9094** (alertmanager cluster port) as well as **imcp**.

Additionally, you can pass a list of groups that will fulfill each of the following roles:
- **bastion**: Security groups that will have access to the cluster members on port **22** as well as **icmp** traffic.
- **client**: Security groups that will have access to the cluster members on ports **9093** as well as icmp traffic.
- **metrics_server**: Security groups that will have access to the cluster members on ports **9093** and **9100** as well as icmp traffic.

# Usage

## Variables

The module takes the following variables as input:

- **member_group_name**: Name to give to the security group for the cluster members
- **client_group_ids**: List of ids of security groups that should have **client** access to the alertmanager cluster
- **bastion_group_ids**: List of ids of security groups that should have **bastion** access to the alertmanager cluster
- **metrics_server_group_ids**: List of ids of security groups that should have **metrics server** access to the alertmanager cluster

## Output

The module outputs the following variables as output:

- **member_group**: Security group for the alertmanager cluster that got created. It contains a resource of type **openstack_networking_secgroup_v2**