# Liquibase Reference Repository

Este repositorio ilustra la estructura completa de Liquibase para GESCOMPH utilizando changelogs en formato JSON. Está organizado por capas de configuración, documentación y objetos de base de datos para seguir el orden de ejecución ordenado.

## Árbol de contenido
- `Configuration Files/`: propiedades de Liquibase, changelog maestro (`changelog.json`) y utilidades como `docker-compose` y plantillas de CI.
- `Documentation/`: guías, manuales y normas de contribución.
- `Database Objects/`: carpetas numeradas que ejecutan el esquema en orden (tablas antes de funciones, vistas, datos y actualizaciones). Cada una contiene un changelog (`00000_changelog.json`) que incluye otros JSON (`00001_...`) con la lógica en línea; `09_inserts` numera sus semillas secuencialmente desde `00001_*` para mantenerlas alineadas y evitar duplicados.
- `Rollbacks/`: archivos JSON con los statements que permiten documentar o ejecutar rollbacks de cada `changeset`.
