create schema if not exists raw;
create schema if not exists staging;
create schema if not exists mart;

grant all on schema raw to postgres;
grant all on schema staging to postgres;
grant all on schema mart to postgres;

alter default privileges in schema raw grant all on tables to postgres;
alter default privileges in schema staging grant all on tables to postgres;
alter default privileges in schema mart grant all on tables to postgres;
