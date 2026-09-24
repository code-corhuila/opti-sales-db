-- pgcrypto: gen_random_bytes and friends for future hashing needs of the domain.
-- Trusted extension since PostgreSQL 13, so it does not need a superuser.
CREATE EXTENSION IF NOT EXISTS pgcrypto;
