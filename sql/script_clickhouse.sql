
select *
from postgresql('postgres:5432','pgdb','valute_data','userpg','passwordpg','pgclick')

--------

CREATE TABLE my_database.pg_valute
ENGINE = PostgreSQL('postgres:5432','pgdb','valute_data','userpg','passwordpg','pgclick')

select *
from my_database.pg_valute;

--------

CREATE DATABASE pg_database
ENGINE = PostgreSQL('postgres:5432','pgdb','userpg','passwordpg','pgclick')

SHOW TABLES FROM pg_database;

select *
from pg_database.valute_data;





