{% hw_interfaces = salt['grains.get']('ip_interfaces', '') %}

mine_functions:
  network.get_hostname: []
  network.interfaces: []
  network.ip_addrs:
{% if 'eth0' in hw_interfaces %}
    - eth0
{% else %}
    cidr: 192.168.0.0/16
{% endif %}
 grains.items: []
