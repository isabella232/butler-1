mine_functions:
  network.get_hostname: []
  network.interfaces: []
  network.ip_addrs:
    - eth0
  network.fqdn_ip4: []
  grains.items: []
  fqdn_ip4:
    - mine_function: grains.get
    - fqdn_ip4
