#!/bin/bash

set -ex
workdir=/opt/freebayes
mkdir -p $workdir
# chmod 777 $workdir
cd $workdir
git clone --recursive git://github.com/ekg/freebayes.git
cd freebayes
make
make install
ln -s /usr{/local,}/bin/freebayes
ln -s /usr{/local,}/bin/bamleftalign
ln -s /opt/freebayes/freebayes/SeqLib/htslib/{tabix,bgzip,htsfile} /usr/bin
