#!/bin/bash
# proper SQL Database initialization 
psql < ./database/clear.sql
psql < ./database/create.sql
psql < ./database/functions_triggers.sql
psql < ./database/client_functions.sql
psql < ./database/person_functions.sql
psql < ./database/challenge_functions.sql
psql < ./database/insert.sql
