#!/usr/bin/env bash
# Rebuild check (numeral 5.2.8): build from an empty database, prove it is incremental,
# revert everything with the U scripts, and build again.
#
# Needs a reachable PostgreSQL. Defaults match .github/workflows/db-ci.yml.
set -euo pipefail

SCHEMA="${SCHEMA:-sales}"
export PGHOST="${PGHOST:-localhost}" PGPORT="${PGPORT:-5432}"
export PGUSER="${PGUSER:-postgres}" PGPASSWORD="${PGPASSWORD:-postgres}" PGDATABASE="${PGDATABASE:-postgres}"
FLYWAY_IMAGE="${FLYWAY_IMAGE:-flyway/flyway:11.20.3}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

flyway() {
  docker run --rm --network host -v "$ROOT:/workspace:ro" \
    -e FLYWAY_URL="jdbc:postgresql://${PGHOST}:${PGPORT}/${PGDATABASE}" \
    -e FLYWAY_USER="$PGUSER" -e FLYWAY_PASSWORD="$PGPASSWORD" \
    "$FLYWAY_IMAGE" -workingDirectory=/workspace -configFiles=/workspace/flyway.toml "$@"
}

schema_exists() {
  psql -Atc "SELECT count(*) FROM information_schema.schemata WHERE schema_name = '${SCHEMA}'"
}

echo "== 1. migrate from an empty database"
flyway migrate

echo "== 2. migrate again: must apply nothing"
flyway migrate | tee /tmp/second-run.log
grep -q "Schema \"${SCHEMA}\" is up to date. No migration necessary." /tmp/second-run.log

echo "== 3. revert with the U scripts, highest version first"
find "$ROOT/05_rollbacks" -name 'U*__*.sql' | while read -r file; do
    name="$(basename "$file")"; number="${name#U}"; number="${number%%__*}"
    echo "$((10#$number)) $file"
  done | sort -rn | cut -d' ' -f2- |
  while read -r script; do
    echo "   $(basename "$script")"
    psql -v ON_ERROR_STOP=1 -q -f "$script"
  done
test "$(schema_exists)" = "0" || { echo "schema ${SCHEMA} still exists after the rollback"; exit 1; }

echo "== 4. build again after the rollback"
flyway migrate
test "$(schema_exists)" = "1"
echo "OK: rebuild, incremental run, full rollback and re-apply all passed"
