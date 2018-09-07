Tips and tricks...

- install terraform from https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip, just unzip and put in place.

- For debugging terraform, set TF_LOG=DEBUG OS_DEBUG=1

- Note that the db-master needs 4GB RAM, I'm not sure about other nodes minimum requirements

- to SSH into the nodes, use the ssh-config file provided as part of the build. From the directory with this file in it:
  - ssh -F ssh-config salt-master

- If the salt master doesn't come up properly, you can try to bring stuff up by hand and get it all in the running state:
  - ssh -F ssh-config salt-master
  - salt '*' state.highstate

- To view the aiflow website after running an example, set up a tunnel, then visit localhost:8889/airflow in your browser
  - ssh -F ssh-config -L 8889:airflow.service.consul:8889 salt-master

- To set up a bastion on T-systems:
  - standard CentOS7 latest, s2.medium image, private IP address, it's own keypair.
    - s2.medium doesn't seem to be big enough, need lots of RAM to support lots of connections?
    - go for s2.2xlarge.1 (8 vCPU, 8GB)
  - edit /etc/ssh/sshd_config and set 'AllowTcpForwarding yes', then
  - as root, 'systemctl restart sshd.service'
   (that needs to be done on all hosts!)

- To check SSH forwarding through the bastion:
  - ssh -i $target_key -o 'ProxyCommand ssh -i $bastion_key linux@$bastion_ip -W %h:%p' linux@$target_ip

- Make sure the bastion has the correct keys in ~/.ssh, and a config file that looks more or less like this:
[linux@t-bastion ~]$ cat .ssh/config 
Host *
  User      linux
  StrictHostKeyChecking no
  IdentityFile          ~/.ssh/tony-bastion.key
  UserKnownHostsFile    /dev/null
- don't forget to set permissions 0400 on ~/.ssh/config!

- To prepare the chr20 data field, extracted from the full genome, run the following:
  > wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz
  > gzip -dv human_g1k_v37.fasta.gz
  > cat human_g1k_v37.fasta.fasta | \
    awk '/^>/ {if(N>0) printf("\n"); printf("%s\n",$0);++N;next;} { printf("%s",$0);} END {printf("\n");}' | \
    split -l 2 - seq_
  > for f in seq_a*; do j=`head -1 $f | tr -d '>' | awk '{ print $1 }'`; echo $f $j; cp $f human_g1k_v37.${j}.fasta; done
  > for f in human_g1k_v37.*.fasta; do samtools faidx $f; done
  > rm -f seq_*

- the input data volume is 23.1 TB

-----
To install onedata client:
  > curl -sS  http://get.onedata.org/oneclient.sh | bash
  > mkdir -p /data

  # For older versions...
  > oneclient -i -H ebi-hinxton.onedata.hnsc.otc-service.com \
    -t YOUR-TOKEN \
    /path/to/local/mount \
    --force-direct-io \
    --monitoring-type graphite --monitoring-level-full --monitoring-period 5 --graphite-url tcp://192.168.50.118:2003 --graphite-namespace-prefix "oneclient-${HOSTNAME}" \
    -o allow_other

  # For 18.02.0-rc4
  # N.B. we _should_ be using ebi-hinxton.onedata.hnsc.otc-service.com, but they don't want us to...
  > oneclient -i -H ebi-otc.onedata.hnsc.otc-service.com \
    -t YOUR-TOKEN \
    /data \
    --force-direct-io \
    -o allow_other \
    --force-fullblock-read  \
    --rndrd-prefetch-cluster-window=10485760 \
    --rndrd-prefetch-cluster-block-threshold=5 \
    --provider-timeout=7200 \
    -v 1

see file oneclient.token.txt for the token value

- if you need to install the client manually:
  > rpm -i http://packages.onedata.org/yum/centos/7x/x86_64/oneclient-18.02.0.rc4-1.el7.centos.x86_64.rpm
  > rpm -i http://packages.onedata.org/yum/centos/7x/x86_64/oneclient-18.02.0.rc5-1.el7.centos.x86_64.rpm

- make sure grafana is running, set up dashboards
  > ssh -F ssh-config -L 3000:grafana.service.consul:3000 salt-master

  > sudo salt -G 'roles:monitoring-server' cmd.run 'service grafana-server start'
  > sudo salt -G 'roles:monitoring-server' cmd.run 'service grafana-server status'
  > sudo salt -G 'roles:monitoring-server' state.apply grafana/create_data_source
  > sudo salt -G 'roles:monitoring-server' state.apply grafana # ignore failures if grafana is already installed

Go to localhost:3000, grafana login: admin/admin

Wave 2 OneClient tests definition at https://docs.google.com/document/d/1bWrFAelYurU6UeQprJLpdriURqKtjFBIHCIi7D7PFU8/edit#heading=h.68qgh2mr3e6l

- use the mapped bam files, write output back to the OTC-EMBL/Tony directory

- use OTC-EMBL/HG00100/alignment/HG00100.mapped.ILLUMINA.bwa.GBR.low_coverage.20130415.bam for initial test
- the data is also available via FTP from ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data/

--------------
Possible recipe for fixing a wedged worker:
- set workers to 0
- terraform apply
- set workers to 1
- terraform apply
- ssh into salt-master
  - salt '*' state.highstate

--------------
To re-start airflow
- on the tracker
  - airflow resetdb
  - airflow initdb
- on salt-master
  - salt 'tracker' state.apply airflow
  - salt 'tracker' state.apply airflow.init-db
  - salt 'tracker' state.apply airflow.init
  - salt 'tracker' state.apply airflow.patch-airflow-db-conns.sls
  - salt 'tracker' state.apply airflow.patch-airflow-url-prefix
  - salt 'tracker' state.apply airflow.server
  - salt 'tracker' state.apply airflow.worker

-------------
Getting the worker entries for the ssh-config file:
ssc salt-master sudo ./get-worker-ssh-config.sh 2>/dev/null | tee -a ssh-config

-------------
For large clusters:
- make sure 'agent' is set to 'false'
> terraform apply --parallelism=20 --auto-approve

-------------
Salt:
- kick a minion into the desired state: On the minion...
> salt-call state.apply

-------------
- post-install, the remaining setup items are:
  - Build the ssh-config file for the bastion and salt-master
    - on salt-master, run the get-worker-ssh-config.sh script
    - on t-bastion, scp the ~/.ssh/config file back

  - Mount the onedata volume
    - *** Check worker.tf, see if it can be mounted automatically? ***
    - from salt-master, run mount-oneclient.sh on workers
    - salt-epilogue.sh has code for this, needs testing...

  - From salt-master, run set-freebayes-reference-genome.sh on the workers, to use the full reference genome
    - or, unzip the reference data in /opt/butler/examples/data/ref, unless you do the above
    - salt-epilogue.sh has code for this, needs testing...

  - Set up the analysis json files
    - on tracker, cd /opt/butler/examples/analyses/freebayes-discovery; mv run-config{,.sav}; tar xf run-config.tgz
    - salt-epilogue.sh has code for this, needs testing...

  - Launch the analysis!
    - on tracker: execute run-freebayes.sh

---------------
we have observed that you mostly use flavors out of our XEN Pools (c1, c2, m1 und s1) within your HNSciCloud Tenants.
We would recommend using flavors out of our KVM Pools (especially S2, M2) if possible, because these flavors offers more Performance normally and they have a good pricing

---------------
if you can't ping consul services, check consul, then dnsmasq, then /etc/resolv.conf.
Make sure that 127.0.0.1 is in the list of nameservers!
