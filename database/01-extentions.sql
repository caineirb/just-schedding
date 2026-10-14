-- If run outside docker, use these (just uncomment the two lines below):
-- CREATE DATABASE "schematic_db";
-- \c "schematic_db";

ALTER DATABASE "schematic_db" SET timezone TO 'UTC';

CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pgcrypto;