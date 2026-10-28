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
  case "$S" in
    queued|running) echo "ещё в работе: $S…"; continue ;;
    done) break ;;
    *) printf '%s\n' "$R" >&2; exit 1 ;;
  esac
done
echo "готово: $S"
# result.ref — приватный JSON полного ответа; передаём ссылку вызывающему.
# Скачать её можно с ключом владельца и текущими правами, как описано в api.md.
printf '%s' "$R" | python3 -c 'import json,sys; r=json.load(sys.stdin)["result"]; value=r if r.get("ref") else r["data"] if r.get("data") is not None else {"result":"\n".join(c["text"] for c in r.get("content", []) if c["type"] == "text")}; print(json.dumps(value, ensure_ascii=False, indent=1))'
