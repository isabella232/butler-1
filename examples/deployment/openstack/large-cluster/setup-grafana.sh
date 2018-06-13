#!/bin/bash

sudo salt -G 'roles:monitoring-server' cmd.run 'service grafana-server start'
sudo salt -G 'roles:monitoring-server' cmd.run 'service grafana-server status'
sudo salt -G 'roles:monitoring-server' state.apply grafana/create_data_source
sudo salt -G 'roles:monitoring-server' state.apply grafana
