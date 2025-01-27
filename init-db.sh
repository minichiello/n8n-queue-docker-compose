#!/bin/bash
set -e

# Criar o usuário não-root se ele não existir
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  DO
  \$do\$
  BEGIN
      IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$POSTGRES_NON_ROOT_USER') THEN
          CREATE USER $POSTGRES_NON_ROOT_USER WITH PASSWORD '$POSTGRES_NON_ROOT_PASSWORD';
      END IF;
  END
  \$do\$;

  -- Garantir que o usuário não-root tenha os privilégios necessários
  GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_NON_ROOT_USER;
  
  -- Conectar ao banco n8n e conceder privilégios em todos os schemas futuros
  \c $POSTGRES_DB;

  -- Garantir acesso ao schema public
  GRANT ALL ON SCHEMA public TO $POSTGRES_NON_ROOT_USER;
  GRANT ALL ON ALL TABLES IN SCHEMA public TO $POSTGRES_NON_ROOT_USER;
  GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO $POSTGRES_NON_ROOT_USER;
  GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO $POSTGRES_NON_ROOT_USER;
  
  -- Configurar privilégios padrão para objetos futuros
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO $POSTGRES_NON_ROOT_USER;
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO $POSTGRES_NON_ROOT_USER;
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO $POSTGRES_NON_ROOT_USER;
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TYPES TO $POSTGRES_NON_ROOT_USER;

  -- Garantir que o usuário possa criar no schema public
  ALTER SCHEMA public OWNER TO $POSTGRES_NON_ROOT_USER;
EOSQL
