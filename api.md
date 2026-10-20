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
| `DELETE /api/v1/me` | удалить свою учётную запись, ключ, файлы и сайты |
| `GET /api/v1/tools` | инструменты со схемами аргументов (JSON Schema); без ключа |
| `POST /api/v1/tools/<имя>` | вызвать инструмент |
| `POST /api/v1/tools/<имя>?async=1` | вызвать, не дожидаясь: сразу номер задачи |
| `GET /api/v1/jobs` | свои задачи |
| `GET /api/v1/jobs/<id>?wait=N` | состояние и результат задачи; `wait` — сколько секунд подождать готовности, не больше 60 (в примерах — 30) |
| `DELETE /api/v1/jobs/<id>` | отменить задачу |
| `POST /api/v1/files?name=<имя>` | загрузить свой файл (тело запроса — файл, до 32 МБ) → ссылка `upload:<id>/<имя>` |
| `GET /api/v1/files` · `DELETE /api/v1/files/<id>` | свои файлы и занятое место; удалить |
| `GET /api/v1/files/<id>/<имя>` | скачать файл по ссылке — свой или переданный вам |
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

Тело — аргументы инструмента. Что принимает каждый (опции песочниц, сборка `build`, ссылки на файлы,
пределы) — [arguments.md](arguments.md); машинно — `GET /api/v1/tools` и `openapi.json`.

## Свои файлы

Модель STL для Blender, проект QElectroTech, документ Markdown — загрузите файл и подставьте ссылку в
аргументы инструмента:

```sh
curl -sS -X POST 'https://v2.spiridus.ru/api/v1/files?name=model.stl' \
  -H "Authorization: Bearer $SPIRIDUS_KEY" --data-binary @model.stl
# {"ref":"upload:4c23262dcc968948/model.stl","id":"4c23262dcc968948","name":"model.stl","size":105,"existed":false}
```

| Куда | Аргумент |
|---|---|
| `blender_run` | `"inputs": ["upload:…/model.stl"]`, в сценарии — `load("model.stl")` |
| `qet_run` | `"project": "upload:…/shema.qet"` |
| `qet_call` | `"put": {"shema.qet": "upload:…/shema.qet"}` |
| `render_check` | `"markdown_file": "upload:…/doc.md"` — вместо `markdown` |

Файлы видны только вам. Один и тот же файл второй раз места не занимает: ссылка зависит от
содержимого, поэтому и готовый результат по ней берётся из кеша. Место — до 500 МБ, файл — до 32 МБ
(Blender принимает входной файл до 24 МБ, документ для `render_check` — до 512 КБ). Через MCP — инструмент
`files_upload` с содержимым в base64, до 10 МБ.

## Поделиться документом

Готовый документ можно показать человеку живым, как его видит читатель: `document_share` сохраняет
его и отдаёт ссылку.

```sh
curl -sS -X POST https://v2.spiridus.ru/api/v1/tools/document_share \
  -H "Authorization: Bearer $SPIRIDUS_KEY" -H 'content-type: application/json' \
  -d '{"markdown": "# Схема\n\n```mermaid\nflowchart LR\n  A --> B\n```\n"}'
# data: {"id":"4ZcR…","version":"6324238542fc","versions":1,"url":"https://v2.spiridus.ru/d/4ZcR…",…}
```

- Ссылка `url` открывается **без ключа** — у любого, кому вы её дали; в поисковики страница не отдаётся.
- Поправили документ — вызовите снова с `"id": "<id>"`: новая версия по той же ссылке. Прежние
  версии остаются: `…/d/<id>?v=<version>`. Тот же текст второй раз версии не добавляет.
- Менять и удалять документ может только тот, кто его опубликовал.
- Документ — строкой `markdown` или файлом `markdown_file` (`upload:…/doc.md`), до 512 КБ; документов —
  до 200 на учётную запись.
- Блоки, которые рисует сервер, показывают готовые результаты (`result: artifact:…`) — сначала
  проверьте документ `render_check`. Свои файлы (`upload:…`) читатель ссылки не увидит: они только с ключом.

Без ключа читаются и сами документы — для своих программ:

| Адрес | Что |
|---|---|
| `GET /api/v1/docs/<id>.md` | текст документа; `?v=<version>` — версии |
| `GET /api/v1/docs/<id>` | заголовок, когда создан и изменён, версии с датами |

## Асинхронные вызовы

Инструменты с песочницами (`plantuml_run`, `hdl_synth`, `modelica_run`, `cad_run`, `blender_run`…)
работают от секунд до минут и ждут в общей очереди. Чтобы не держать соединение:

```sh
# поставить задачу — ответ сразу, 202 и номер
curl -sS -X POST 'https://v2.spiridus.ru/api/v1/tools/plantuml_run?async=1' \
  -H "Authorization: Bearer $SPIRIDUS_KEY" -H 'content-type: application/json' \
  -d '{"source": "Alice -> Bob: привет"}'
# {"id":"91818451…","status":"running","poll":"/api/v1/jobs/91818451…?wait=30"}

# забрать результат: wait=30 — ждёт готовности до 30 с (можно до 60), иначе отвечает status: running — спросите ещё раз
curl -sS "https://v2.spiridus.ru/api/v1/jobs/91818451…?wait=30" -H "Authorization: Bearer $SPIRIDUS_KEY"
```

`status` — `running`, `done` (результат — в `result`, как у обычного вызова), `error`, `cancelled`.
Скрипт целиком — [`examples/async.sh`](examples/async.sh), на Python — [`examples/spiridus.py`](examples/spiridus.py).

## Лимиты и очередь

Сейчас идёт **альфа-тестирование**: лимиты могут меняться; текущие — в `GET /api/v1/me`.

**На пользователя** (по ключу; в MCP и REST — общие):

| Что | Предел |
|---|---|
| вызовов в час — тяжёлых (рисование на сервере, `render_check`) | 600 |
| вызовов в час — лёгких (справка, примеры, файлы) | 6000 |
| обычных вызовов одновременно | 2 |
| незаконченных асинхронных задач | 100; хранятся последние 1000 записей о задачах |
| своих файлов | 500 МБ, до 5000 файлов |
| опубликованных документов | 200, каждый до 512 КБ |
| сайтов для вызовов из браузера | 10 |
| частота запросов с одного адреса | REST — 2 в секунду, кратковременно до 20–50 сразу; MCP — 20 в секунду |

**Размеры запроса:**

| Что | Предел |
|---|---|
| тело вызова REST (`/api/v1/tools/…`) | 2 МБ |
| файл через `POST /api/v1/files` | 32 МБ |
| тело запроса MCP | 16 МБ; файл через `files_upload` — до 10 МБ (в base64) |
| документ `render_check` (строкой или файлом) | 512 КБ |
| исходник PlantUML, Structurizr, Modelica, сценарий FreeCAD и Blender | 256 КБ |
| исходник HDL | 512 КБ, или до 32 файлов по 512 КБ (вместе до 2 МБ) |
| программа OpenQASM | 128 КБ |
| текст `text_parse` | 20 000 знаков, разбираются первые 60 предложений |
| входной файл Blender | 24 МБ, до 8 файлов, вместе до 32 МБ |

**Время работы** одного вызова на сервере (дольше — прерывается, ответ — ошибка «время»):

| Инструменты | Предел |
|---|---|
| `render_check` | 180 с |
| `plantuml_run`, `quantum_run`, `cad_run` | 120 с |
| `structurizr_run`, `modelica_run`, `qet_run`, `qet_call` | 180 с |
| `text_parse` | 150 с |
| `hdl_synth`, `hdl_sim`, `blender_run` | 300 с |

К этому добавляется ожидание в очереди: синхронный вызов ждёт ответа до 300 с всего, долгие —
асинхронно ([ниже](#асинхронные-вызовы)).

**Очередь.** Песочницы — одна очередь на всех. Кто много потратил за последние полчаса-час, стоит в ней
дальше тех, кто тратит мало, — но не вечно: ожидание его поднимает. Одинаковый вызов (тот же инструмент,
аргументы и версия программы) берётся из кеша сразу, без очереди и без расхода лимита на рисование.

**До входа** (регистрация): с одного адреса — 3 в час, на одну почту — 3 в сутки, всего — 50 в час;
подтверждений с адреса — 20 в час. Слишком часто — `429` и через сколько повторить.

## Форматы ответов

**Вызов инструмента** — `POST /api/v1/tools/<имя>`:

```json
{ "ok": true, "data": { … }, "content": [ { "type": "text", "text": "…" }, { "type": "image", "data": "…base64…", "mimeType": "image/png" } ] }
```

- `data` — первый текстовый ответ инструмента, разобранный как JSON; если ответ — не JSON (справка
  `render_block_docs` — это Markdown), `data` — `null`, текст — в `content`;
- `content` — ответ целиком, как у MCP: `text`, `image` (картинки в base64), `resource_link` (ссылки на файлы);
- для чатов (`/api/v1/chat/tools/<имя>`, спецификация `openapi-chat.json`) — только результат: объект
  `data` или `{ "result": "текст" }`, без `content`.

**Ошибки** — `{ "error": "…" }` и код; у неверных аргументов ещё `issues` — что и где не так:

| Код | Что |
|---|---|
| 400 | запрос не тот: аргументы, имя файла, JSON |
| 401 | нужен ключ |
| 403 | учётная запись заблокирована или сайт не добавлен к ней |
| 404 | нет такого инструмента, задачи или файла |
| 413 | слишком большой запрос или файл, кончилось место |
| 422 | инструмент вернул ошибку: `{ "ok": false, "data": null, "content": [ { "type": "text", "text": "…" } ] }` |
| 429 | лимит или очередь полна — повторите позже |

**Задача** (`?async=1`, `/api/v1/jobs/<id>`):

```json
{ "id": "91818451…", "tool": "plantuml_run", "status": "done", "queuedAt": "…", "finishedAt": "…", "ms": 2999,
  "result": { "ok": true, "data": { … }, "content": [ … ] } }
```

`status` — `running`, `done`, `error` (и `error` с текстом), `cancelled`.

**Главное в `data` у инструментов:**

| Инструмент | Поля |
|---|---|
| `render_check` | `clean` — чисто ли; `issues` — замечания `{ line, kind, text, hint, at }` (`at` — ширины окна; `hint` — у первого замечания каждого рецепта); `blocks`, `errors`; `artifact`, `files` — снимки; `preview` — снимок строкой Markdown; `show_user` — что сделать дальше. Картинки в ответе — только при замечаниях к рисункам или со сценариями `interact`. `brief: true` — без `hint`, `show_user` и `files`, картинки — только вырезы проблемных блоков |
| `plantuml_run`, `structurizr_run`, `quantum_run`, `hdl_synth`, `hdl_sim`, `modelica_run`, `qet_run` | `artifact` — id результата; `files` — ссылки на файлы; `block` (и `fence`) — готовые строки для блока документа, уже со сборкой; `warnings` или ошибка со строкой |
| `cad_run`, `blender_run` | `artifact`, `files` (модели, кадры); объём, габариты, объекты; `block` — блок ```stl со сборкой, если есть модель STL |
| все инструменты песочниц | `build` — id сборки, в которой посчитано (и без `build` в запросе), `buildImage` — sha256 её образа. Чтобы результат не менялся с новой версией программы, запишите сборку в документ — [blocks/sandbox.md](blocks/sandbox.md#как-закрепить-результат) |
| `text_parse` | `block` — готовый блок ```conllu; `parsers` — время и лицензия анализаторов |
| `render_examples` | `blocks` — примеры `{ lang, where, page, section, code, features }`; `recipes` — `{ lang, kind, do, ok }` |
| `render_block_docs` | справка Markdown (в `content`) |
| `files_upload`, `POST /api/v1/files` | `{ ref, id, name, size, existed }` — `ref` подставляют в аргументы |

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
