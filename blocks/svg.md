<!-- Собрано из notations/svg/docs.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

# `svg` — произвольный рисунок

Разметка SVG целиком, с `viewBox` или `width`/`height`. Показывается картинкой: скрипты,
обработчики событий, `foreignObject` и ссылки наружу вычищаются.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 80">
  <polygon points="10,70 110,70 40,10" fill="#e7f0ff" stroke="#1d4ed8"/>
</svg>
```

Не больше 32 КБ. Без размеров рисунок не показывается.

## Как чинить замечания `render_check`

`render_check` смотрит внутрь рисунка: `label-crossed` — линия через подпись, `label-tight` — линия касается подписи, `label-overlap` — подписи налезают, `label-outside` — подпись шире своей фигуры, `label-small` — после ужатия под колонку мельче 9 точек. В замечании — текст подписи, а в ответе — вырез места (`label-<строка>-<n>.png`).

- `label-crossed`, `label-tight` — сдвиньте `<text>` (x, y) или линию; подложка под текстом — `<rect fill="white">` перед `<text>`.
- `label-overlap` — разведите подписи, `text-anchor="end"` для левой.
