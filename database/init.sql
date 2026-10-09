-- If run outside docker, use these (just uncomment the two lines below):
-- CREATE DATABASE "schematic_db";
-- \c "schematic_db";

ALTER DATABASE "schematic_db" SET timezone TO 'UTC';

CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE "role" AS ENUM ('user', 'admin');

-- Trigger function to update the column value automatically
CREATE OR REPLACE FUNCTION update_modify_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CLOCK_TIMESTAMP();
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- Trigger function to automatically hash the password
CREATE OR REPLACE FUNCTION hash_user_password()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the password is being set or changed
    IF TG_OP = 'INSERT' OR NEW.password_hash IS DISTINCT FROM OLD.password_hash THEN
        -- Prevent double-hashing if the password is already a bcrypt hash ($2a$, $2b$, or $2y$)
        IF NEW.password_hash !~ '^\$2[aby]\$[0-9]{2}\$' THEN
            NEW.password_hash := crypt(NEW.password_hash, gen_salt('bf', 10));
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TABLE IF NOT EXISTS "users" (
    "username" VARCHAR(50) NOT NULL PRIMARY KEY,
    "name" VARCHAR(150) NOT NULL,
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "password_hash" TEXT NOT NULL,
    "role" "role" NOT NULL DEFAULT 'user', 
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Every update on the user, it should automatically update the "updated_at" column
CREATE TRIGGER update_users_modtime
    BEFORE UPDATE ON "users"
    FOR EACH ROW
    EXECUTE FUNCTION update_modify_column();

-- Every insert to the users table or update on the password_hash column, this will fire 
CREATE TRIGGER trg_hash_password
    BEFORE INSERT OR UPDATE ON "users"
    FOR EACH ROW
    EXECUTE FUNCTION hash_user_password();