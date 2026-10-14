-- Enums
CREATE TYPE "role" AS ENUM ('user', 'admin');

CREATE TABLE IF NOT EXISTS "users" (
    "username" VARCHAR(50) NOT NULL PRIMARY KEY,
    "name" VARCHAR(150) NOT NULL,
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "password_hash" TEXT NOT NULL,
    "role" "role" NOT NULL DEFAULT 'user', 
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);