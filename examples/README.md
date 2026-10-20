# Примеры

Всё в этой папке — [MIT-0](LICENSE): копируйте куда угодно без условий.

| Файл | Что делает |
|---|---|
| [`register.sh`](register.sh) | регистрация: `./register.sh you@example.com` — письмо со ссылкой, ключ — на странице подтверждения |
| [`check.sh`](check.sh) | проверить свой документ Markdown: `SPIRIDUS_KEY=sp_… ./check.sh документ.md` |
| [`async.sh`](async.sh) | асинхронный вызов песочницы: поставить задачу и дождаться результата |
| [`mcp.sh`](mcp.sh) | инструмент по MCP напрямую, JSON-RPC через curl: `./mcp.sh render_block_docs '{"lang": "mermaid"}'` |
| [`spiridus.py`](spiridus.py) | клиент на Python без зависимостей: `register`, `me`, `tools`, `check`, `call`, `async` |

Документы с блоками — образцы для моделей — в [`documents/`](documents/).
