#!/bin/bash
# proper SQL Database initialization 
psql < ./clear.sql
psql < ./create.sql
psql < ./functions_triggers.sql
psql < ./insert.sql
