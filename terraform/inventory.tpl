[juniper]
vsrx-tf-1
vsrx-tf-2
vsrx-tf-3

[juniper:vars]
ansible_user=labuser
ansible_network_os=junipernetworks.junos.junos
ansible_connection=netconf
ansible_netconf_ssh_config=~/.ssh/config
ansible_host_key_checking=false