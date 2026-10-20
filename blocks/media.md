<!-- Собрано из packages/render/src/media.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

# Картинки из внешних источников

Обычная картинка Markdown со ссылкой на страницу файла Викисклада:

```markdown
![Строение цветка](https://commons.wikimedia.org/wiki/File:Mature_flower_diagram.svg)
```

Так она выглядит в документе:

![Строение цветка](https://commons.wikimedia.org/wiki/File:Mature_flower_diagram.svg)

Подходит и прямая ссылка на файл `upload.wikimedia.org`. Файл берётся из пакета данных `media`
(браузер читателя в источник не ходит) и показывается с подписью: автор, лицензия со ссылкой,
источник, что изменено. В пакет попадает только то, что можно хранить и раздавать:
общественное достояние, CC0, CC BY, CC BY-SA.

Файла нет в пакете — вместо рисунка карточка со ссылкой на источник:

![Несуществующий рисунок](https://commons.wikimedia.org/wiki/File:Spiridus_no_such_file_demo.svg)

Список того, что есть в пакете, — MCP-инструмент `render_media`.
