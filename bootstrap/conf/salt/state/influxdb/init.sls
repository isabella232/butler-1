influxdb:
  pkg.installed:
    - sources:
      - influxdb: https://s3.amazonaws.com/influxdb/influxdb-0.9.3-1.x86_64.rpm
  service.running:
    - require:
      - pkg: influxdb
    - watch:
      - file: /etc/opt/influxdb/influxdb.conf
  
/var/lib/.influxdb:
  file.directory:
    - user: influxdb
    - group: influxdb
    - dir_mode: 755
    - file_mode: 644
/var/lib/.influxdb/data:
  file.directory:
    - user: influxdb
    - group: influxdb
    - dir_mode: 755
    - file_mode: 644
/var/lib/.influxdb/meta:
  file.directory:
    - user: influxdb
    - group: influxdb
    - dir_mode: 755
    - file_mode: 644
/var/lib/.influxdb/hh:
  file.directory:
    - user: influxdb
    - group: influxdb
    - dir_mode: 755
    - file_mode: 644
/var/lib/.influxdb/wal:
  file.directory:
    - user: influxdb
    - group: influxdb
    - dir_mode: 755
    - file_mode: 644    
    
/etc/opt/influxdb/influxdb.conf:
  file.managed:
    - source: salt://influxdb/config/influxdb.conf
    - user: influxdb
    - group: influxdb
    - mode: 644

influxdb_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/influxdb_consul.json
    - source: salt://influxdb/config/influxdb_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True    
