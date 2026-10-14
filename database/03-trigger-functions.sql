---------------------------------
-- Define Trigger Functions
---------------------------------

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