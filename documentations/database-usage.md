# Queries for using the database (NO ORM IS ALLOWED)

> **Security Note (Parameterization)**:
> Since **no ORM** is used, never concatenate raw user inputs into SQL strings to avoid SQL injection.
> Both raw SQL examples and parameterized query equivalents (e.g. `$1, $2` for `asyncpg` or `%s` for `psycopg`) are provided below.

---

## FOR "users" TABLE

### 1. INSERT (Registration)

Plaintext passwords passed into `"password_hash"` are automatically hashed using bcrypt by the `trg_hash_password` database trigger.

```sql
INSERT INTO "users" ("username", "name", "email", "password_hash", "role") VALUES
('kunnow', 'Shir Keilah Connor', 'shirkunnow@gmail.com', 'frontendko', 'admin'),
('giosanchez0208', 'Gio Kiefer Sanchez', 'giosanchez0208@gmail.com', 'bayotko', 'admin'),
('caineirb', 'Caine Ivan Bautista', 'caine.bautista@gmail.com', 'pinakagwapoko', 'admin');
```

**Parameterized (Backend / Driver usage):**

```sql
INSERT INTO "users" ("username", "name", "email", "password_hash", "role")
VALUES ($1, $2, $3, $4, $5)
RETURNING "username", "name", "email", "role", "created_at";
```

---

### 2. AUTHENTICATION / LOGIN

Verifies login credentials using `crypt()` against the stored bcrypt hash. Returns the user record if email and password match, or 0 rows if credentials are invalid.

```sql
SELECT "username", "name", "email", "role", "created_at"
FROM "users"
WHERE "email" = 'giosanchez0208@gmail.com'
  AND "password_hash" = crypt('bayotko', "password_hash");
```

**Parameterized (Backend / Driver usage):**

```sql
SELECT "username", "name", "email", "role", "created_at"
FROM "users"
WHERE "email" = $1
  AND "password_hash" = crypt($2, "password_hash");
```

---

### 3. CHECK PASSWORD VALIDITY (Boolean Check)

Returns `true` or `false` indicating whether the entered password matches the stored hash for a given user.

```sql
SELECT "username", 
       ("password_hash" = crypt('bayotko', "password_hash")) AS is_password_correct
FROM "users"
WHERE "username" = 'giosanchez0208';
```

**Parameterized (Backend / Driver usage):**

```sql
SELECT "username", 
       ("password_hash" = crypt($1, "password_hash")) AS is_password_correct
FROM "users"
WHERE "username" = $2;
```

---

### 4. GET PUBLIC PROFILE

Fetches user information while **always omitting** `password_hash` to avoid leaking hashes to the client or frontend.

```sql
SELECT "username", "name", "email", "role", "created_at", "updated_at"
FROM "users"
WHERE "username" = 'caineirb';
```

**Parameterized (Backend / Driver usage):**

```sql
SELECT "username", "name", "email", "role", "created_at", "updated_at"
FROM "users"
WHERE "username" = $1;
```

---

### 5. UPDATE PROFILE INFO

Updates profile details such as name or email. The `update_users_modtime` trigger automatically updates the `"updated_at"` column.

```sql
UPDATE "users"
SET "name" = 'Caine I. Bautista',
    "email" = 'caine.new@gmail.com'
WHERE "username" = 'caineirb'
RETURNING "username", "name", "email", "updated_at";
```

**Parameterized (Backend / Driver usage):**

```sql
UPDATE "users"
SET "name" = $1,
    "email" = $2
WHERE "username" = $3
RETURNING "username", "name", "email", "updated_at";
```

---

### 6. CHANGE / RESET PASSWORD

When `password_hash` is updated, the `trg_hash_password` trigger automatically hashes the new plaintext password.

```sql
UPDATE "users"
SET "password_hash" = 'new_super_secret_password'
WHERE "username" = 'kunnow'
RETURNING "username", "updated_at";
```

**Parameterized (Backend / Driver usage):**

```sql
UPDATE "users"
SET "password_hash" = $1
WHERE "username" = $2
RETURNING "username", "updated_at";
```

---

### 7. CHANGE USER ROLE (Promote / Demote)

Updates a user's role to either `'user'` or `'admin'`.

```sql
UPDATE "users"
SET "role" = 'admin'
WHERE "username" = 'kunnow'
RETURNING "username", "role", "updated_at";
```

**Parameterized (Backend / Driver usage):**

```sql
UPDATE "users"
SET "role" = $1
WHERE "username" = $2
RETURNING "username", "role", "updated_at";
```

---

### 8. SEARCH / LIST USERS (Pagination & Filtering)

Lists users with pagination (`LIMIT` and `OFFSET`) and optional filtering by role.

```sql
SELECT "username", "name", "email", "role", "created_at"
FROM "users"
WHERE "role" = 'user'
ORDER BY "created_at" DESC
LIMIT 20 OFFSET 0;
```

**Parameterized (Backend / Driver usage):**

```sql
SELECT "username", "name", "email", "role", "created_at"
FROM "users"
WHERE ($1::role IS NULL OR "role" = $1)
ORDER BY "created_at" DESC
LIMIT $2 OFFSET $3;
```

---

### 9. DELETE USER

Deletes a user record by username.

```sql
DELETE FROM "users"
WHERE "username" = 'kunnow'
RETURNING "username";
```

**Parameterized (Backend / Driver usage):**

```sql
DELETE FROM "users"
WHERE "username" = $1
RETURNING "username";
```
