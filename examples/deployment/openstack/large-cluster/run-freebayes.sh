#!/bin/bash
#
# The data and reference data need to be correct on the worker node(s), regardless of
# other nodes
#
# The config files need to be correct on the tracker node, where the DAG is built.
#

set -ex

examples=/opt/butler/examples

if [ `hostname` != 'tracker' ]; then
  echo "Not on host 'tracker', please log in there and run this"
  exit 0
fi

sudo -i \
butler create-workflow \
	-n freebayes \
	-v 1.0 \
	-c $examples/workflows/freebayes-workflow/freebayes-workflow-config.json | tee create-workflow.log

sudo -i \
butler create-analysis \
	-n freebayes \
	-d 01-01-2017 \
	-c $examples/analyses/freebayes-discovery/analysis.json | tee create-analysis.log

#
# N.B. Need the workflow and analysis IDs here!
wid=`cat create-workflow.log | egrep 'Created workflow with ID:' | awk '{ print $NF }'`
echo "wid=$wid"

aid=`cat create-analysis.log | egrep 'Created analysis with ID:' | awk '{ print $NF }'`
echo "aid=$aid"

sudo -i \
butler launch-workflow \
	-w $wid \
	-a $aid \
	-c $examples/analyses/freebayes-discovery/run-config/
