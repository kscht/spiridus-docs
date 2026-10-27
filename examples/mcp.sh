#!/bin/sh
# Вызвать инструмент Spiridus по MCP напрямую, без библиотеки: JSON-RPC запросом POST.
# Запуск: SPIRIDUS_KEY=sp_… ./mcp.sh render_block_docs '{"lang": "mermaid"}'
# По умолчанию — ядро и схемы; другой пресет задаётся через SPIRIDUS_MCP.
#         SPIRIDUS_KEY=sp_… ./mcp.sh            — список инструментов
set -eu
: "${SPIRIDUS_KEY:?нужен ключ: export SPIRIDUS_KEY=sp_…}"
MCP=${SPIRIDUS_MCP:-https://v2.spiridus.ru/mcp/p/diagrams}
if [ $# -eq 0 ]; then
  BODY='{"jsonrpc": "2.0", "id": 1, "method": "tools/list"}'
else
  # аргументы по умолчанию — отдельной строкой: «${2:-{}}» разные sh разбирают по-разному
  ARGS=${2:-}
  [ -n "$ARGS" ] || ARGS='{}'
  BODY="{\"jsonrpc\": \"2.0\", \"id\": 1, \"method\": \"tools/call\", \"params\": {\"name\": \"$1\", \"arguments\": $ARGS}}"
fi
curl -fsS "$MCP" -H "Authorization: Bearer $SPIRIDUS_KEY" -H 'content-type: application/json' \
  -H 'Accept: application/json, text/event-stream' --data-binary "$BODY" | python3 -c '
import json, sys
r = json.load(sys.stdin)
if "error" in r: sys.exit("ошибка: " + r["error"]["message"])
res = r["result"]
if "tools" in res:
    for t in res["tools"]: print(t["name"], "—", t.get("title", ""))
else:
    typed = "structuredContent" in res and not res.get("isError")
    plain = res.get("_meta", {}).get("spiridus/textResult")
    printed = False
    for c in res["content"]:
        if c["type"] == "text" and typed and not printed and not plain:
            print(json.dumps(res["structuredContent"], ensure_ascii=False, indent=1))
        else:
            print(c["text"] if c["type"] == "text" else "[" + c["type"] + "]")
        if c["type"] == "text": printed = True
'
