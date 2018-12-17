#!/bin/bash

## Version of aggregator script
aggregatorscriptversion='1.0'

## Version of SimPLU3D-openmole release
simplu3dopenmolescripversion='1.0'


wget https://github.com/julienperret/aggregator/releases/download/v$aggregatorscriptversion/aggregator-$aggregatorscriptversion.zip

unzip aggregator-$aggregatorscriptversion.zip

rm aggregator-$aggregatorscriptversion.zip

echo "You can now run the aggregator script in the directory aggregator-1.0/bin/"

echo "For instance ./aggregator-1.0/bin/aggregator inputData cadastre truth temp output_workflow/parcels.shp"


wget https://github.com/SimPLU3D/simplu3D-openmole/releases/download/V$simplu3dopenmolescripversion/SimPLU3D-openmole-release.zip

unzip SimPLU3D-openmole-release.zip

rm SimPLU3D-openmole-release.zip
