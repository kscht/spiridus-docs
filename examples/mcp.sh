#!/bin/sh
# Вызвать инструмент Spiridus по MCP напрямую, без библиотеки: JSON-RPC запросом POST.
# Запуск: ./mcp.sh render_block_docs '{"lang": "mermaid"}'
#         ./mcp.sh            — список инструментов
# По умолчанию — проекты; другой адрес задаётся через SPIRIDUS_MCP.
#
# Сессия (набор инструментов в разговоре) живёт между запусками скрипта:
#   export SPIRIDUS_MCP=https://v2.spiridus.ru/mcp
#   export SPIRIDUS_SESSION=$(./mcp.sh init)    — initialize, печатает Mcp-Session-Id
#   ./mcp.sh tools '{"use": "diagrams"}'        — дальше каждый запрос идёт с этим id
#   ./mcp.sh close                              — DELETE: закрыть сессию явно
# Сам скрипт сессию никогда не закрывает; без close она живёт 24 часа после последнего обращения
# (на учётную запись — до 100 сессий, сверх закрывается наименее недавно использованная).
#
# Код выхода 1 — ошибка HTTP или JSON-RPC и ответ инструмента с isError (текст ошибки печатается).
#
# SPIRIDUS_FIELD=имя — напечатать только это поле ответа (например id из session_open):
#   K=$(SPIRIDUS_FIELD=id ./mcp.sh session_open '{}')
set -eu
: "${SPIRIDUS_KEY:?задайте SPIRIDUS_KEY вне репозитория}"
MCP=${SPIRIDUS_MCP:-https://v2.spiridus.ru/mcp/p/projects}
SESSION=${SPIRIDUS_SESSION:-}
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# post BODY — POST на MCP с заголовком сессии, если он задан; заголовки ответа — в $TMP/h, тело — в $TMP/b
post() {
  set -- -sS -o "$TMP/b" -D "$TMP/h" -w '%{http_code}' "$MCP" -H 'content-type: application/json' \
    -H 'Accept: application/json, text/event-stream' --data-binary "$1"
  if [ -n "$SESSION" ]; then set -- "$@" -H "Mcp-Session-Id: $SESSION"; fi
  # ключ — через stdin curl (-H @-), чтобы он не попадал в список процессов
  printf 'Authorization: Bearer %s\n' "$SPIRIDUS_KEY" | curl -H @- "$@"
}

case ${1:-} in
init)
  [ -z "$SESSION" ] || { echo "SPIRIDUS_SESSION уже задан; для новой сессии уберите его" >&2; exit 1; }
  CODE=$(post '{"jsonrpc": "2.0", "id": 0, "method": "initialize", "params": {"protocolVersion": "2025-06-18", "capabilities": {}, "clientInfo": {"name": "mcp.sh", "version": "1"}}}')
  [ "$CODE" = 200 ] || { echo "initialize: HTTP $CODE: $(cat "$TMP/b")" >&2; exit 1; }
  SESSION=$(sed -n 's/^[Mm][Cc][Pp]-[Ss]ession-[Ii][Dd]: *\([^[:space:]]*\).*/\1/p' "$TMP/h")
  [ -n "$SESSION" ] || { echo "шлюз не выдал Mcp-Session-Id (гостевой ключ?)" >&2; exit 1; }
  CODE=$(post '{"jsonrpc": "2.0", "method": "notifications/initialized"}')
  case $CODE in 2??) ;; *) echo "notifications/initialized: HTTP $CODE" >&2; exit 1 ;; esac
  echo "$SESSION"
  exit 0 ;;
close)
  : "${SPIRIDUS_SESSION:?нужен SPIRIDUS_SESSION — id из ./mcp.sh init}"
  CODE=$(printf 'Authorization: Bearer %s\n' "$SPIRIDUS_KEY" | curl -sS -o "$TMP/b" -w '%{http_code}' -X DELETE "$MCP" \
    -H @- -H "Mcp-Session-Id: $SESSION")
  [ "$CODE" = 200 ] || { echo "close: HTTP $CODE: $(cat "$TMP/b")" >&2; exit 1; }
  echo "сессия закрыта"
  exit 0 ;;
''|list) BODY='{"jsonrpc": "2.0", "id": 1, "method": "tools/list"}' ;;
*)
  # аргументы по умолчанию — отдельной строкой: «${2:-{}}» разные sh разбирают по-разному
  ARGS=${2:-}
  [ -n "$ARGS" ] || ARGS='{}'
  BODY="{\"jsonrpc\": \"2.0\", \"id\": 1, \"method\": \"tools/call\", \"params\": {\"name\": \"$1\", \"arguments\": $ARGS}}" ;;
esac
CODE=$(post "$BODY")
# ответ — JSON или поток SSE (строки «data: {…}»); 404 с id — сессия истекла или закрыта
python3 -c '
import json, sys
code, raw = sys.argv[1], open(sys.argv[2], encoding="utf-8").read()
# строки data: одного события SSE склеиваются через перевод строки, события разделяет пустая строка
msgs, data = [], None
for line in raw.splitlines() + [""]:
    if line.startswith("data:"):
        v = line[5:]
        v = v[1:] if v.startswith(" ") else v
        data = v if data is None else data + "\n" + v
    elif not line and data is not None: msgs.append(data); data = None
if not msgs: msgs = [raw]
r = None
for m in msgs:
    try: x = json.loads(m)
    except ValueError: continue
    if isinstance(x, dict) and ("result" in x or "error" in x): r = x
if r is None: sys.exit("HTTP " + code + ": " + raw[:500])
if "error" in r:
    # JSON-RPC: {"error": {"message": …}}; 401, 403, 413 и неизвестный пресет: {"error": "…"}
    err = r["error"]
    msg = err.get("message") if isinstance(err, dict) else err
    hint = ("\nсессия не найдена: unset SPIRIDUS_SESSION; export SPIRIDUS_SESSION=$(./mcp.sh init)"
            if code == "404" and sys.argv[4] else "")
    sys.exit("HTTP " + code + ": " + str(msg) + hint)
res = r["result"]
if "tools" in res:
    for t in res["tools"]: print(t["name"], "—", t.get("title", ""))
else:
    typed = "structuredContent" in res and not res.get("isError")
    field = sys.argv[3]
    if field:
        if not typed or field not in res["structuredContent"]: sys.exit("в ответе нет поля " + field + ": " + json.dumps(res, ensure_ascii=False)[:500])
        v = res["structuredContent"][field]
        print(v if isinstance(v, str) else json.dumps(v, ensure_ascii=False))
        sys.exit(0)
    plain = res.get("_meta", {}).get("spiridus/textResult")
    printed = False
    for c in res["content"]:
        if c["type"] == "text" and typed and not printed and not plain:
            print(json.dumps(res["structuredContent"], ensure_ascii=False, indent=1))
        else:
            print(c["text"] if c["type"] == "text" else "[" + c["type"] + "]")
        if c["type"] == "text": printed = True
    if res.get("isError"): sys.exit(1)
' "$CODE" "$TMP/b" "${SPIRIDUS_FIELD:-}" "$SESSION"
