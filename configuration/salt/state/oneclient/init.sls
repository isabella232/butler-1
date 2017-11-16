install_oneclient:
  # Add repository
  pkgrepo.managed:
    - humanname: OneClient repository
    - baseurl: http://packages.onedata.org/yum/centos/7x
    - gpgkey: http://packages.onedata.org/onedata.gpg.key
    - name: oneclient

    # Install package
  pkg.installed:
    - name: oneclient

# Create mountpoint
{{ pillar['oneprovider_mountpoint'] }}:
  file.directory:
    - user: centos
    - group: centos

mount_space:
  cmd.run:
    - name: oneclient {% if pillar['oneprovider_insecure'] %} -i {% endif %} --force-direct-io -H {{ pillar['oneprovider_host'] }} -t {{ pillar['oneprovider_token'] }} {{ pillar['oneprovider_mountpoint'] }}
    - user: airflow
