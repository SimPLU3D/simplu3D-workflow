#!/bin/bash

wget https://github.com/julienperret/aggregator/releases/download/v1.0/aggregator-1.0.zip

unzip aggregator-1.0.zip

echo "You can now run the aggregator script in the directory aggregator-1.0/bin/"

echo "For instance ./aggregator-1.0/bin/aggregator inputData cadastre truth temp output_workflow/parcels.shp"
