#!/bin/bash
set -e

# Create the non-root user if it does not exist
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  DO
  \$do\$
  BEGIN
      IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$POSTGRES_NON_ROOT_USER') THEN
          CREATE USER $POSTGRES_NON_ROOT_USER WITH PASSWORD '$POSTGRES_NON_ROOT_PASSWORD';
      END IF;
  END
  \$do\$;

  -- Ensure the non-root user has the necessary privilegesecessários
  GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_NON_ROOT_USER;
  
  -- Connect to the n8n database and grant privileges on all future schemas
  \c $POSTGRES_DB;

  -- Ensure access to the public schema
  GRANT ALL ON SCHEMA public TO $POSTGRES_NON_ROOT_USER;
  GRANT ALL ON ALL TABLES IN SCHEMA public TO $POSTGRES_NON_ROOT_USER;
  GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO $POSTGRES_NON_ROOT_USER;
  GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO $POSTGRES_NON_ROOT_USER;
  
  -- Set default privileges for future objects
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO $POSTGRES_NON_ROOT_USER;
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO $POSTGRES_NON_ROOT_USER;
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO $POSTGRES_NON_ROOT_USER;
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TYPES TO $POSTGRES_NON_ROOT_USER;

  -- Ensure the user can create in the public schema
  ALTER SCHEMA public OWNER TO $POSTGRES_NON_ROOT_USER;
EOSQL
