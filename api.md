# REST API

Адрес — `https://v2.spiridus.ru/api/v1/`. Описание в OpenAPI 3.1 — [`/api/v1/openapi.json`](https://v2.spiridus.ru/api/v1/openapi.json):
его удобно отдать модели целиком.

Инструменты — те же, что у [MCP](mcp.md): у каждого свой адрес, аргументы — тело запроса JSON.

## Вход

Ключ из регистрации ([getting-started.md](getting-started.md)) — в заголовке:

```
Authorization: Bearer sp_...
```

| Адрес | Что |
|---|---|
| `POST /api/v1/register` `{ "email": … }` | письмо со ссылкой подтверждения; без ключа |
| `GET /api/v1/me` | кто я и мои лимиты |
| `GET /api/v1/tools` | инструменты со схемами аргументов (JSON Schema); без ключа |
| `POST /api/v1/tools/<имя>` | вызвать инструмент |
| `POST /api/v1/tools/<имя>?async=1` | вызвать, не дожидаясь: сразу номер задачи |
| `GET /api/v1/jobs` | свои задачи |
| `GET /api/v1/jobs/<id>?wait=30` | состояние и результат задачи, подождать до 60 с |
| `DELETE /api/v1/jobs/<id>` | отменить задачу |
| `GET /api/v1/origins` · `POST` · `DELETE` `{ "origin": … }` | сайты, с которых ваши страницы зовут API из браузера |
| `GET /api/v1/openapi.json` | описание API; без ключа |
| `GET /api/v1/openapi-chat.json` | то же для чатов: только инструменты модели; `?tools=a,b` — свой набор |

## Вызов инструмента

```sh
curl -sS -X POST https://v2.spiridus.ru/api/v1/tools/render_block_docs \
  -H "Authorization: Bearer $SPIRIDUS_KEY" -H 'content-type: application/json' \
  -d '{"lang": "mermaid"}'
```

Ответ:

```json
{ "ok": true, "data": …, "content": [ … ] }
```

- `data` — первый текстовый ответ инструмента, разобранный как JSON (у большинства — объект с результатом);
- `content` — ответ целиком, как у MCP: `text`, `image` (base64), `resource_link`;
- неверные аргументы — `400` со списком `issues`; ошибка инструмента — `422` и `ok: false`.

## Асинхронные вызовы

Инструменты с песочницами (`plantuml_run`, `hdl_synth`, `modelica_run`, `cad_run`, `blender_run`…)
работают от секунд до минут и ждут в общей очереди. Чтобы не держать соединение:

```sh
# поставить задачу — ответ сразу, 202 и номер
curl -sS -X POST 'https://v2.spiridus.ru/api/v1/tools/plantuml_run?async=1' \
  -H "Authorization: Bearer $SPIRIDUS_KEY" -H 'content-type: application/json' \
  -d '{"source": "Alice -> Bob: привет"}'
# {"id":"91818451…","status":"running","poll":"/api/v1/jobs/91818451…?wait=30"}

# забрать результат: ждёт готовности до 30 с, иначе отвечает status: running — спросите ещё раз
curl -sS "https://v2.spiridus.ru/api/v1/jobs/91818451…?wait=30" -H "Authorization: Bearer $SPIRIDUS_KEY"
```

`status` — `running`, `done` (результат — в `result`, как у обычного вызова), `error`, `cancelled`.
Скрипт целиком — [`examples/async.sh`](examples/async.sh), на Python — [`examples/spiridus.py`](examples/spiridus.py).

## Лимиты и очередь

- Лимиты — на пользователя: вызовов в час (тяжёлых, с песочницами, и лёгких — отдельно) и сколько
  обычных вызовов одновременно; незаконченных асинхронных задач — до 100. Текущие — в `GET /api/v1/me`.
- Песочницы — одна очередь на всех. Кто много потратил за последние полчаса-час, стоит в ней дальше
  тех, кто тратит мало, — но не вечно, ожидание его поднимает.
- Одинаковый вызов (тот же инструмент, аргументы и версия программы) берётся из кеша сразу, без песочницы.
- Слишком часто — `429` и через сколько повторить.

## Вызовы из браузера: свой сайт

Скрипты, curl и серверы ходят без ограничений. Если API зовёт **страница в браузере** — ваш Open WebUI,
своё приложение, — браузер пустит запрос, только если сайт записан к вашей учётной записи (CORS).
Добавьте его один раз — curl'ом или скриптом, не из этого браузера:

```sh
curl -sS -X POST https://v2.spiridus.ru/api/v1/origins \
  -H "Authorization: Bearer $SPIRIDUS_KEY" -H 'content-type: application/json' \
  -d '{"origin": "https://webui.example.org"}'
```

Сайт — схема, имя и порт, без пути: `https://webui.example.org`, `http://localhost:8080`. До 10 сайтов;
убрать — тот же запрос с `DELETE`. С сайта, которого нет в списке, запрос с вашим ключом получит `403`.
То же правило — для MCP.

## Ответы об ошибках

`{ "error": "…" }` и код: `400` — запрос не тот, `401` — нужен ключ, `403` — запись заблокирована или
запрос со стороннего сайта, `404` — нет такого инструмента или задачи, `422` — инструмент вернул
ошибку, `429` — лимит.
