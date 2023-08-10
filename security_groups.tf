resource "openstack_networking_secgroup_v2" "alertmanager_member" {
  name                 = var.member_group_name
  description          = "Security group for alertmanager members"
  delete_default_rules = true
}

//Allow all outbound traffic from alertmanager members
resource "openstack_networking_secgroup_rule_v2" "alertmanager_member_outgoing_v4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "alertmanager_member_outgoing_v6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

//Allow port 9093 and 9094 traffic from other members
resource "openstack_networking_secgroup_rule_v2" "peer_alertmanager_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9093
  port_range_max    = 9093
  remote_group_id  = openstack_networking_secgroup_v2.alertmanager_member.id
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "peer_alertmanager_cluster_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9094
  port_range_max    = 9094
  remote_group_id  = openstack_networking_secgroup_v2.alertmanager_member.id
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "peer_icmp_access_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = openstack_networking_secgroup_v2.alertmanager_member.id
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "peer_icmp_access_v6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = openstack_networking_secgroup_v2.alertmanager_member.id
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

//Allow port 22 and icmp traffic from the bastion
resource "openstack_networking_secgroup_rule_v2" "internal_ssh_access" {
  for_each          = { for idx, id in var.bastion_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_access_v4" {
  for_each          = { for idx, id in var.bastion_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_access_v6" {
  for_each          = { for idx, id in var.bastion_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

//Allow port 9093 and icmp traffic from the client
resource "openstack_networking_secgroup_rule_v2" "client_alertmanager_access" {
  for_each          = { for idx, id in var.client_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9093
  port_range_max    = 9093
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "client_icmp_access_v4" {
  for_each          = { for idx, id in var.client_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "client_icmp_access_v6" {
  for_each          = { for idx, id in var.client_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

//Allow port 9093, 9100 and icmp traffic from metrics server
resource "openstack_networking_secgroup_rule_v2" "metrics_server_node_exporter_access" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "metrics_server_alertmanager_exporter_access" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9093
  port_range_max    = 9093
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "metrics_server_icmp_access_v4" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}

resource "openstack_networking_secgroup_rule_v2" "metrics_server_icmp_access_v6" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.alertmanager_member.id
}