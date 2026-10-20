#!/bin/sh
# Проверить документ Markdown: render_check рисует его, как увидит читатель, и возвращает замечания.
# Запуск: SPIRIDUS_KEY=sp_… ./check.sh документ.md
set -eu
FILE=${1:?файл Markdown: ./check.sh документ.md}
: "${SPIRIDUS_KEY:?нужен ключ: export SPIRIDUS_KEY=sp_…}"
API=${SPIRIDUS_API:-https://v2.spiridus.ru}
# документ — строкой JSON; python3 есть почти везде, а экранировать Markdown руками — мучение
BODY=$(python3 -c 'import json,sys; print(json.dumps({"markdown": open(sys.argv[1], encoding="utf-8").read(), "shots": "none"}))' "$FILE")
curl -fsS -X POST "$API/api/v1/tools/render_check" \
  -H "Authorization: Bearer $SPIRIDUS_KEY" -H 'content-type: application/json' \
  --data-binary "$BODY" | python3 -c '
import json, sys
d = json.load(sys.stdin)["data"]
print("чисто" if d.get("clean") else "есть замечания")
for i in d.get("issues", []):
    print("  строка", i.get("line"), "—", i["kind"] + ":", i["text"])
'
