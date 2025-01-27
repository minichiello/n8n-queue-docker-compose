
# Creating n8n with Queues Using Docker Compose

This guide provides instructions for setting up n8n with queues using Docker Compose. The setup includes environment variables, commands, and notes to ensure a smooth deployment.

---

## Environment Variables

Below are the environment variables required for configuring n8n, Postgres, and Redis:

```env
# The top-level domain to serve from
DOMAIN_NAME=example.com

# The subdomain to serve from
SUBDOMAIN=n8n

# The full URL where the webhooks will be accessible
WEBHOOK_URL=https://n8n.example.com/

# Optional timezone to set which gets used by Cron-Node by default
# If not set, New York time will be used
GENERIC_TIMEZONE=Europe/Berlin

# Encryption key used by n8n for securing sensitive data
N8N_ENCRYPTION_KEY=encryptionkey123

# Enforces strict file permissions for settings files to enhance security
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# The email address to use for the SSL certificate creation
SSL_EMAIL=user@example.com

# Postgres database configuration
POSTGRES_USER=root
POSTGRES_PASSWORD=postgrespasswordroot123
POSTGRES_DB=n8n
POSTGRES_NON_ROOT_USER=postgres
POSTGRES_NON_ROOT_PASSWORD=postgrespassword123

# Redis configuration
REDIS_PASSWORD=redispassword123
```

## Commands

Use the following commands to manage your n8n setup:

### Start the n8n service in detached mode

    sudo docker compose up -d

### Stop the n8n service

    sudo docker compose stop

## Notes

 - Postgres Version: n8n recommends using Postgres 13 or higher for
   optimal performance and compatibility.
 - Execution Mode: When running n8n in queue execution mode, avoid using
   an SQLite database. It is not recommended for production
   environments.
 - Security: Ensure that the N8N_ENCRYPTION_KEY is kept secure and not
   shared publicly.
 - Timezone: Set the GENERIC_TIMEZONE variable to match your preferred
   timezone for Cron-Node operations. If not set, the default timezone
   is New York.
