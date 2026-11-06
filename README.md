# opti-sales-db

> sales bounded context: database (schema, seeds, migrations)

Part of the **LMS Library** distributed system — team `lms-library`, Grupo 2.
Governance and documentation live in [`library-docs`](https://github.com/code-corhuila/library-docs).

## Branching

Three permanent branches. **None of them accepts a direct commit** — you enter through a child
branch and leave through a Pull Request.

```
develop  <--PR--  feat/... fix/... chore/...
qa       <--PR--  qa/...
main     <--PR--  release/...  hotfix/...
```

Promotion happens **by re-application** (`git cherry-pick -x`), never by merging one permanent
branch into another: `merge develop -> qa` and `merge qa -> main` do not exist in this model.

`main` requires **1 approval from `ariel5253`**. On `develop` and `qa` the team sets its own review
rule.

Full policy: `00-governance/branching-policy.md` in `library-docs`.

## V020: comprobantes privados de pago

Migración aditiva `V020__private_payment_receipts.sql`: `payment_receipt` conserva contenido binario y MIME, vinculado a pago/factura, con límite de 2 MiB y tipos PDF/PNG/JPEG. Otorga SELECT/INSERT solo a `sales_writer`; el lector general de reportes no obtiene acceso. La API exige roles ADMIN/SELLER para descargar; no existe exposición por archivos públicos. Ningún pago histórico se modifica ni requiere backfill.

Aplicar esta migración antes de actualizar la API de ventas. Validación cloud en PostgreSQL 16 aislado: migración desde cero, repetición incremental sin cambios y pruebas JDBC de persistencia/rollback junto al pago. No se ejecutan scripts de rollback ni limpieza en este trabajo. Los comprobantes de prueba deben ser ficticios.

La inversa U020 se entrega para revisión y se niega a borrar una tabla con comprobantes. No se ejecutó. El commit de este PR lleva `[skip ci]`: el workflow existente ejecuta borrados/rollback completos; se evita dispararlo por la restricción explícita de esta tarea. Se comprobaron localmente migraciones e integración sin borrados.
