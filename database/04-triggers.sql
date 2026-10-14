---------------------------------
-- Create Triggers
---------------------------------


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