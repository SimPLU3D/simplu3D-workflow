#!/bin/bash
# assumes postgresql and postgis are installed, database $db_name exists, and a Java 8 runtime is installed

export PGPASSWORD='imrandb'
# db creds
db_host="localhost"
db_name="iauidf_from_scratch"
db_user="imrandb"

# java program conf
jarFile="simplushp2pgsql-0.0.11-shaded.jar"
confFile="creds.conf"
run_number="151218"

# sql file used to create the joined table between parcelles and regles
sql_creating_simuls_sdp_errors="results_to_db.sql"

# db tables where we import the results' shapefiles and log. Names must be the same
# as those in the sql file $sql_creating_simuls_sdp_errors
simuls_sdp_table="public.simuls_sdp"
simuls_errors_table="public.simuls_errors"

# names of csv resulting from formating output
output_csv_raw='./results_simu/output.csv'
outputCleaned="simuls_sdp.csv"
errorsCleaned="simuls_errors.csv"


# 1/ import geoms in database
echo "java -jar ${jarFile} ${confFile} ${run_number}"
java -jar $jarFile $confFile $run_number

# 2/ format output.csv for db import
# first we remove empty lines and comment lines, then we trim spaces, eventually add a field for number of iterations, and we add the column for 'run' 
echo "writing ${outputCleaned}..."
cat $output_csv_raw | awk NF | sed '/^#/ d' | tr -d ' ' | awk -F';' -v OFS=';' '{for(i=NF+1;i<=5;i++)$i=$4}1' | awk '{ if(NR==1){print $0";run"} else{print $0";'"$run_number"'"} }'  > $outputCleaned
echo "...done"
echo "writing ${errorsCleaned}..."
# we get the comments lines starting with #, extract the directory number and add the 'run' id
echo "directory;run" > $errorsCleaned 
cat $output_csv_raw | grep \# | grep -o [0-9]\* | awk '{ print $0";'"$run"'" }' >> $errorsCleaned 
echo "...done"

# 3/ create db tables
psql -h $db_host -d $db_name -U $db_user -a -f $sql_creating_simuls_sdp_errors

# 4/ and import csv created at step #2
psql -h $db_host -d $db_name -U $db_user -c "\COPY $simuls_sdp_table FROM '$outputCleaned' delimiter ';' csv header;"
psql -h $db_host -d $db_name -U $db_user -c "\COPY $simuls_errors_table FROM 'simuls_errors.csv' delimiter ';' csv header;"

