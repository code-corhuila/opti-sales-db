-- Reverts V002. Dropping the schema also removes the Flyway history table, so a later migrate starts clean.
DROP SCHEMA IF EXISTS sales CASCADE;
