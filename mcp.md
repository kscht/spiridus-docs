# MCP

Сервер MCP Spiridus — `https://v2.spiridus.ru/mcp` (Streamable HTTP). Ключ — тот же, что для REST API
([getting-started.md](getting-started.md)), в заголовке `Authorization: Bearer sp_...`.

## Подключить

**Claude Code:**

```sh
claude mcp add --transport http spiridus https://v2.spiridus.ru/mcp \
  --header "Authorization: Bearer $SPIRIDUS_KEY"
```

Ключ сохранится в ваших настройках Claude Code (`~/.claude.json`), не в проекте. Не добавляйте с
`--scope project`: тогда он попадёт в `.mcp.json` в папке проекта и легко уйдёт в git. Если сервер нужен
в общем `.mcp.json` проекта — только с подстановкой из окружения: `"Authorization": "Bearer ${SPIRIDUS_KEY}"`.

**Cursor, Windsurf и другие клиенты с файлом настроек** (`mcp.json`) — ключ не вписывайте в файл,
подставляйте из переменной окружения; в Cursor это `${env:ИМЯ}`:

```json
{
  "mcpServers": {
    "spiridus": {
      "url": "https://v2.spiridus.ru/mcp",
      "headers": { "Authorization": "Bearer ${env:SPIRIDUS_KEY}" }
    }
  }
}
```

Как пишется подстановка в вашем клиенте — смотрите его документацию. Если клиент её не умеет и ключ
приходится вписать в файл — держите этот файл вне проекта (в настройках пользователя, а не в
`.cursor/mcp.json` репозитория) или добавьте его в `.gitignore`.

**Open WebUI** — двумя путями:

- как сервер инструментов OpenAPI (Settings → Tools / Tool Servers): URL `https://v2.spiridus.ru`,
  спецификация `api/v1/openapi-chat.json` (только инструменты модели; полная — `api/v1/openapi.json`),
  авторизация Bearer — ваш ключ. Каждый инструмент
  Spiridus станет инструментом модели; удобнее, если модели нужны асинхронные задачи;
- как сервер MCP (Streamable HTTP), если ваша версия Open WebUI это умеет: адрес `https://v2.spiridus.ru/mcp`
  и тот же ключ.

Open WebUI часто зовёт инструменты прямо из браузера — тогда добавьте адрес своего Open WebUI к
учётной записи: [api.md](api.md#вызовы-из-браузера-свой-сайт). Модели — любые с вызовом функций (Qwen3,
Llama, Mistral, DeepSeek, gpt-oss…); у мелких лучше включить «Native» function calling.

**Новые инструменты и параметры.** Список инструментов клиент берёт при подключении и запоминает.
Когда в Spiridus появляется новое (инструмент, параметр), клиент увидит его после переподключения: в
Claude Code — `/mcp`, выбрать `spiridus` и «Reconnect» (или перезапустить), в других клиентах —
перезапустить или переподключить сервер. REST (`GET /api/v1/tools`) всегда отдаёт текущий список.

Клиенты только с локальным stdio подключаются через мост:
`npx mcp-remote https://v2.spiridus.ru/mcp --header "Authorization: Bearer $SPIRIDUS_KEY"`.

## Из своего скрипта

MCP — это JSON-RPC запросами `POST` на один адрес. Сервер работает без сессий: каждый запрос
самостоятелен, ответ — обычный JSON, и **при прямых запросах** шаг `initialize` можно пропустить — наш
сервер его не требует. Нужен заголовок `Accept: application/json, text/event-stream`.

```sh
curl -sS https://v2.spiridus.ru/mcp \
  -H "Authorization: Bearer $SPIRIDUS_KEY" -H 'content-type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  -d '{"jsonrpc": "2.0", "id": 1, "method": "tools/call",
       "params": {"name": "render_block_docs", "arguments": {"lang": "mermaid"}}}'
```

`tools/list` — список инструментов. Скрипт целиком — [`examples/mcp.sh`](examples/mcp.sh).

Библиотекой — для Python `pip install mcp`. Библиотека работает по протоколу целиком и начинает с
`initialize` сама — его вызов в примере нужен ей, а не нашему серверу:

```python
import asyncio, os
from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client

async def main():
    headers = {"Authorization": "Bearer " + os.environ["SPIRIDUS_KEY"]}
    async with streamablehttp_client("https://v2.spiridus.ru/mcp", headers=headers) as (read, write, _):
        async with ClientSession(read, write) as s:
            await s.initialize()
            r = await s.call_tool("render_block_docs", {"lang": "mermaid"})
            print(r.content[0].text[:300])

asyncio.run(main())
```

Для Node — `@modelcontextprotocol/sdk` (`Client` и `StreamableHTTPClientTransport`).

Те же инструменты есть и в [REST API](api.md) — там ещё асинхронные задачи для долгих песочниц.

## Что умеет

Список инструментов с описаниями отдаёт сам сервер (и `GET /api/v1/tools` в REST); для людей — [tools.md](tools.md). Главное:

- `render_blocks`, `render_block_docs` — какие блоки есть и как их писать;
- `render_examples`, `render_recipes` — готовые примеры и рецепты починки замечаний;
- `render_check` — нарисовать документ и получить замечания; снимки блоков и страницы;
- песочницы: `plantuml_run`, `structurizr_run`, `hdl_synth`, `hdl_sim`, `quantum_run`, `modelica_run`,
  `cad_run`, `blender_run`, `qet_run`, `text_parse` — результат вставляется в документ строкой из ответа;
- `document_share` — живая ссылка на документ `https://v2.spiridus.ru/d/<id>`: открывается без ключа,
  как у читателя; с тем же `id` — новая версия по той же ссылке.

Ответы песочниц кешируются: тот же вызов второй раз приходит сразу, с `"cached": true` и временем
первого запуска — [api.md](api.md#кеш-результатов).

Хороший цикл для модели: прочитать `render_block_docs` нужного языка → написать документ →
`render_check` → починить замечания → снова `render_check`, пока не станет чисто → `document_share` и
отдать ссылку человеку.

Лимиты и очередь — как у REST: [api.md](api.md#лимиты-и-очередь). Всё, что приходит через MCP,
сохраняется — [data.md](data.md).
