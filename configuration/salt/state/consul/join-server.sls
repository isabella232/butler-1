{%- set members = salt['mine.get']('roles:(consul-server|consul-bootstrap)', 'network.ip_addrs', 'grain_pcre').values() %}
{%- set node_ip = salt['grains.get']['grains.get']('fqdn_ip4') %}
{%- set join_members = [] %}
{%- for member in members if member[0] != node_ip %}
{% do join_members.append(member[0]) %}
{%- endfor %}
join-all-consul-members:
  cmd.run:
    - names:
{%- for server in join_server %}
      - consul join {{ server }}
{%- endfor %}
