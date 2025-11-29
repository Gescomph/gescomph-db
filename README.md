# gescomph-db

## Liquibase JSON scaffold

This repository stores the database-change artifacts for GESCOMPH and follows a JSON-based Liquibase layout inspired by the `Entity.Infrastructure.Configurations` folder of the `gescomph-api` solution. The [`Configuration Files/changelog.json`](Configuration Files/changelog.json) file wires the master changelog to every numbered directory that lives under `Database Objects`.

Each numbered directory executes a changelog that collects smaller, action-specific JSON change files (for example, `00001_administration_system_modules.json`). Most directories name this file `00000_changelog.json` and number their children sequentially, and `Database Objects/09_inserts` follows the same pattern by numbering its seed scripts from `00001_*`. Use the `Entity.Infrastructure.Configurations` folder as the source of truth for schema names, column lengths, defaults, and relationships: the files currently living in `Database Objects/01_tables` are direct translations of the `AdministrationSystem` configurations for `Modules`, `Forms` and `FormModules`.

## Current reference artifacts

- `Database Objects/01_tables/00001_administration_system_modules.json`: creates `AdministrationSystem.Modules`, applies the unique `Name` constraint, and adds the descending `CreatedAt, Id` index that `BaseModelConfiguration` describes.
- `Database Objects/01_tables/00002_administration_system_forms.json`: mirrors `FormConfiguration` by creating `AdministrationSystem.Forms` with the required `Route` column, nullable `Description`, and a unique `Name`.
- `Database Objects/01_tables/00003_administration_system_formmodules.json`: defines the join table described by `FormModuleConfiguration`, including both foreign keys and the `(FormId, ModuleId)` uniqueness.
- `Database Objects/01_tables/00004_administration_system_systemparameters.json`: creates `AdministrationSystem.SystemParameters`, enforces the unique `Key`, and keeps the common descending `CreatedAt, Id` index from `BaseModelConfiguration`.

Each change set follows the pattern shown below, so adding new tables simply becomes a matter of plugging in the schema name, column definitions, and matching constraints from the entity configuration:

```json
{
  "databaseChangeLog": [
    {
      "changeSet": {
        "id": "your-id",
        "author": "your.name",
        "changes": [
          {
            "createTable": {
              "tableName": "your_table",
              "columns": [ /* columns derived from the Entity configuration */ ]
            }
          }
        ]
      }
    }
  ]
}
```

## How to extend the changelog from `Entity` configs

1. Pick the Entity configuration (e.g., `Entity.Infrastructure.Configurations.AdministrationSystem.ModuleConfiguration`) and match its schema/table name in JSON.
2. Copy the column details, lengths, defaults, and required-ness from `BaseModelConfiguration`/`BaseModelGenericConfiguration`.
3. Translate `HasIndex`, `HasOne`, `HasMany`, and other constraint calls into `createIndex`, `addUniqueConstraint`, `addForeignKeyConstraint`, etc.
4. Drop the JSON file into the relevant directory (`01_tables`, `02_procedures`, `05_views`, ... ) and reference it from that folder’s `00000_changelog.json`.
5. Run Liquibase with the master changelog (`Configuration Files/changelog.json`) to apply the new artifact.

## Running locally

1. Copy `.env.template` to `.env` and set `LIQUIBASE_USER`, `LIQUIBASE_PASSWORD`, and any other secrets so the Liquibase container can authenticate.
2. From `Configuration Files`, run `docker-compose up --build` (the Liquibase container loads `.env` and executes the JSON changelog).
3. Or call Liquibase directly with the property file that matches the SQL Server you want to target:
   - `liquibase --defaultsFile=Configuration Files/liquibase.properties update` (develop)
   - `liquibase --defaultsFile=Configuration Files/liquibase-qa.properties update`
   - `liquibase --defaultsFile=Configuration Files/liquibase-staging.properties update`
   - `liquibase --defaultsFile=Configuration Files/liquibase-main.properties update`
4. Every change set carries the combined `develop,qa,staging,main` context tag so it runs once the matching context is provided by the environment-specific property file.

## Next steps

- Continue translating the remaining schemas/procedures/views from `Entity.Infrastructure.Configurations` into JSON change sets grouped under the numbered folders.
- Keep the environment-specific Liquibase property files and `.env` aligned with the target SQL Server/PostgreSQL credentials.
