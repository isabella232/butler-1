allow_nginx_connect:
  selinux.boolean:
    - name: httpd_can_network_connect
    - value: 1
    - persist: true

nginx:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-available/*
      - file: /etc/nginx/sites-enabled/butler-site

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/config/nginx.conf
    - user: root
    - group: root
    - mode: 640
