#!/bin/sh
# Асинхронный вызов: поставить задачу песочнице и дождаться результата, не держа соединение.
# Запуск: SPIRIDUS_KEY=sp_… ./async.sh
set -eu
: "${SPIRIDUS_KEY:?нужен ключ: export SPIRIDUS_KEY=sp_…}"
API=${SPIRIDUS_API:-https://v2.spiridus.ru}
AUTH="Authorization: Bearer $SPIRIDUS_KEY"
JOB=$(curl -fsS -X POST "$API/api/v1/tools/plantuml_run?async=1" -H "$AUTH" -H 'content-type: application/json' \
  -d '{"source": "Читатель -> Spiridus: документ\nSpiridus -> Читатель: рисунок"}' | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')
echo "задача $JOB"
while :; do
  R=$(curl -fsS "$API/api/v1/jobs/$JOB?wait=30" -H "$AUTH")
  S=$(printf '%s' "$R" | python3 -c 'import json,sys; print(json.load(sys.stdin)["status"])')
  [ "$S" = running ] || break
  echo "ещё в работе…"
done
echo "готово: $S"
printf '%s' "$R" | python3 -c 'import json,sys; j=json.load(sys.stdin); print(json.dumps(j.get("result", {}).get("data", j.get("error")), ensure_ascii=False, indent=1))'
