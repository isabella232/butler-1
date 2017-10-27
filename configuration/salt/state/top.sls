base:
  '*':
    - selinux
    - dnsmasq
    - elastic.filebeat
    - elastic.packetbeat
    - ntp
<<<<<<< HEAD
    - telegraf
  'G@roles:consul-ui':
    - consul.ui
=======
  'G@roles:consul-bootstrap':
    - consul.bootstrap
  'G@roles:consul-server':
    - consul.server
    - consul.join-all
  'G@roles:consul-client':
    - consul.client
    - consul.join-server
>>>>>>> 5c172e2d281b8215140f2ce557d23bc425362d4f
  'G@roles:monitoring-server':
    - influxdb
    - grafana
    - kapacitor
    - chronograf
  'G@roles:worker':
    - git
    - celery
    - airflow
    - airflow.worker
    - butler.tracker
    - butler.deploy.example-workflows
    - cwltool
    - docker
  'G@roles:tracker':
    - git
    - run-tracking-db.set_db_url
    - celery
    - airflow
    - airflow.init-db
    - airflow.patch-airflow-url-prefix
    - airflow.server
    - jsonmerge
    - butler.tracker
    - butler.deploy.example-workflows
    - hostfile
  'G@roles:db-server':
    - postgres
    - run-tracking-db
    - run-tracking-db.create_tables
    - grafana.createdb
    - airflow.airflow-db
  'G@roles:job-queue':
    - rabbitmq
  'G@roles:elasticsearch':
    - elastic.search
    - elastic.logstash
    - elastic.kibana
    - celery
  'G@roles:R':
    - R
  'G@roles:butler-web':
    - git
    - nginx
    - butler.web
