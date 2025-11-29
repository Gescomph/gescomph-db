# Quick start

1. Copia `.env.template` a `.env` y agrega credenciales reales.
2. Ejecuta `docker-compose -f "../Configuration Files/docker-compose.yml" up -d` desde `manual-repo/Configuration Files`.
3. Dentro del contenedor Liquibase ejecuta:
   - `liquibase validate --changelog-file=changelog.json`
   - `liquibase status --changelog-file=changelog.json`
   - `liquibase update`
4. Usa `liquibase history` y `liquibase rollback-count N` para inspeccionar cambios y pruebas; todos los cambios están definidos en JSON bajo `Database Objects/`.
