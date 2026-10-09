# Schemantic Project

## Docker Usage

> [!NOTE]
> Make sure the [Docker Compose Yaml](/docker-compose.yml) and `.env` are in the root directory.

### PostgreSQL w/ pgvector Image

1. Start containers:

   ```bash
   docker compose up -d
   ```

   > This is to start all containers found inside [Docker Compose](/docker-compose.yml)

2. Check for running containers (the Status should be *Up something*):

   ```bash
   docker ps
   ```

   > Take note of the values under the columns `CONTAINER ID` or `NAMES`

3. Access to the PostgreSQL (w/ pgvector)

   ```bash
   docker exec -it <CONTAINER ID | NAMES> psql -U <DB_USER> -d <DB_NAME>
   ```

   > Check `.env` for the values of <DB_USER> and <DB_NAME>

## Creators & Maintainers

| Name | Role | Github |
| :--- | :--: | -----: |
| **Gio Kiefer Sanchez** | *The Choosen Backshot* | [@giosanchez0208](https://github.com/giosanchez0208) |
| **Shir Keilah Connor** | *Prima Facie Frontend* | [@kunnow](https://github.com/kunnow) |
| **Caine Ivan Bautista** | *The Handsome Other Roles* | [@caineirb](https://github.com/caineirb) |
