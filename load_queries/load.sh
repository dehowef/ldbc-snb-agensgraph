#!/bin/bash
#
# This script loads make the LDBC schema and load the specified dataset.
# 
# ./load.sh [CONFIGURATION_FILE]

source $1

agens -e -d $DBNAME -p $PORT -U $USER -f load_queries/enable_fdw.sql -L ldbc_loading.log -q -o load_output.log 2>/dev/null
agens -e -d $DBNAME -p $PORT -U $USER -v source_path=$DATAPATH -v target_db=$DBNAME -f load_queries/schema.sql -L ldbc_loading.log -q -o load_output.log 2>/dev/null

agens -e -d $DBNAME -p $PORT -U $USER -f load_queries/load_vertexes.sql
agens -e -d $DBNAME -p $PORT -U $USER -f load_queries/create_vertex_property_indexes.sql
agens -e -d $DBNAME -p $PORT -U $USER -f load_queries/load_edges.sql
agens -e -d $DBNAME -p $PORT -U $USER -f load_queries/analyze_vertexes.sql
agens -e -d $DBNAME -p $PORT -U $USER -f load_queries/analyze_edges.sql
agens -e -d $DBNAME -p $PORT -U $USER -f load_queries/reindex.sql
agens -e -d $DBNAME -p $PORT -U $USER -f load_queries/prewarm.sql

#agens -e -d $DBNAME -p $PORT -U $USER -f load_queries/weight_precal.sql -L ldbc_loading.log -q -o load_output.log 2>/dev/null
#agens -e -d $DBNAME -p $PORT -U $USER -f load_queries/proc.sql -L ldbc_loading.log -q -o load_output.log 2>/dev/null

