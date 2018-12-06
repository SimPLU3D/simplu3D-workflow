#!/bin/bash
# assumes postgresql and postgis are installed, and database $db_name exists

export PGPASSWORD='imrandb'

# input shapes
parcelle_shape="parcels_94.shp"
mos_shape="mos.shp"
amenagement_shape="amenagement.shp"
regles_shape="regles.shp"


# sql file used to create the joined table between parcelles and regles
sql_creating_parcelles_rules="parcelles_rulez.sql"

# final output shapefile 
output_shape="parcels_rulez"

# db creds
db_host="localhost"
db_name="iauidf_from_scratch"
db_user="imrandb"

# db tables where we import the shapefiles, must be the same as the ones 
# in the sql file $sql_creating_parcelles_rules
parcelle_table="public.parcels"
mos_table="public.mos"
amenagement_table="public.amenagement"
regles_table="public.regles"
join_table="public.parcelles_rulez"

# 1/ import parcels, mos, amenagement, and rules in db
shp2pgsql $parcelle_shape $parcelle_table | psql -h $db_host -d $db_name -U $db_user
shp2pgsql $mos_shape $mos_table | psql -h $db_host -d $db_name -U $db_user
shp2pgsql $amenagement_shape $amenagement_table | psql -h $db_host -d $db_name -U $db_user
shp2pgsql $regles_shape $regles_table | psql -h $db_host -d $db_name -U $db_user

# 2/ create parcelles_rulez db
psql -h $db_host -d $db_name -U $db_user -a -f $sql_creating_parcelles_rules

# 3/ export shapefile
pgsql2shp -f $output_shape -h $db_host -u $db_user -P $PGPASSWORD $db_name $join_table

