# Contributing

1. Crea una rama `HU-00-...` contra `develop` del repo `gescomph-db`.
2. Crea o actualiza los cambiosets JSON/SQL dentro de las carpetas numeradas siguiendo la convención `00001_<descripción>.sql`.
3. Añade el registro de cada nuevo SQL en el `00000_changelog.yaml` correspondiente.
4. Adjunta el rollback asociado en `Rollbacks/11_rollbacks/XX/` si el cambio lo permite.
5. Ejecuta `liquibase update --dryRun` (o `validate`) antes de subir el push.
6. Abre MR explicando el orden de despliegue para los ambientes (develop → staging → qa → main).
