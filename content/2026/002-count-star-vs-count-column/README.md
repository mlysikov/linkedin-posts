# COUNT(*) vs COUNT(column)

Materials for the LinkedIn post: `COUNT(*) vs COUNT(column)`.

## Files

- `post.md` - post text and metadata
- `assets/cover.png` - LinkedIn image
- `docker-compose.yml` - PostgreSQL, ClickHouse, and Oracle lab environment
- `sql/postgresql.sql` - PostgreSQL example
- `sql/clickhouse.sql` - ClickHouse example
- `sql/oracle.sql` - Oracle example

## Run

Start the databases:

```bash
docker compose up -d
```

Connection settings for DBeaver:

- PostgreSQL: `localhost:5432`, database `demo`, user `demo`, password `Password1`
- ClickHouse: `localhost:8123` or `localhost:9000`, database `demo`, user `demo`, password `Password1`
- Oracle: `localhost:1521/FREEPDB1`, user `system`, password `Password1`
- Oracle example schema after running `sql/oracle.sql`: user `demo`, password `Password1`

Wait until both services are healthy:

```bash
docker compose ps
```

PostgreSQL:

```bash
docker compose exec postgres psql -U demo -d demo -f /sql/postgresql.sql
```

ClickHouse:

```bash
docker compose exec -T clickhouse clickhouse-client --user demo --password Password1 --database demo --multiquery < sql/clickhouse.sql
```

Oracle:

```bash
docker compose exec oracle bash -lc "sqlplus -s system/Password1@localhost:1521/FREEPDB1 @/sql/oracle.sql"
```

Stop the databases and remove volumes:

```bash
docker compose down -v
```
