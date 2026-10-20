<!-- Собрано из packages/render/src/blocks/vega/docs.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

# `vega` — диаграммы Vega

Полная спецификация [Vega](https://vega.github.io/vega/) 6: данные с преобразованиями (`transform`),
шкалы, оси, легенды, метки (`marks`), сигналы для взаимодействия. Нужна, когда не хватает
Vega-Lite: деревья, графы с силовой раскладкой, диаграммы Вороного, свои взаимодействия. Для
обычных графиков короче и надёжнее блок `vega-lite`. Спецификация — JSON (можно JSON5).

```vega
{
  "$schema": "https://vega.github.io/schema/vega/v6.json",
  "width": 360, "height": 200, "padding": 5,
  "data": [{"name": "t", "values": [
    {"месяц": "сен", "дни": 21}, {"месяц": "окт", "дни": 22}, {"месяц": "ноя", "дни": 16}, {"месяц": "дек", "дни": 20}
  ]}],
  "scales": [
    {"name": "x", "type": "band", "domain": {"data": "t", "field": "месяц"}, "range": "width", "padding": 0.2},
    {"name": "y", "type": "linear", "domain": {"data": "t", "field": "дни"}, "range": "height", "nice": true}
  ],
  "axes": [
    {"orient": "bottom", "scale": "x"},
    {"orient": "left", "scale": "y", "title": "Учебных дней"}
  ],
  "marks": [{
    "type": "rect", "from": {"data": "t"},
    "encode": {"enter": {
      "x": {"scale": "x", "field": "месяц"}, "width": {"scale": "x", "band": 1},
      "y": {"scale": "y", "field": "дни"}, "y2": {"scale": "y", "value": 0},
      "fill": {"value": "#4c78a8"}
    }}
  }]
}
```

## Данные

Как в `vega-lite`: `"values": [ … ]` в спецификации или файл документа — блок ` ```csv file=<имя> `
(`tsv`, `json`) и `"url": "file:<имя>"` с `"format": {"type": "csv"}` (у Vega формат по
расширению не угадывается: без него — JSON). Адреса в интернете не загружаются — у блока нет сети.

## Что учесть

- Размер — `"width"` и `"height"` у спецификации; `"autosize": "pad"` (по умолчанию) добавляет
  место под оси. Колонка документа — 760 точек.
- Числа и даты подписываются по-русски (десятичная запятая, русские месяцы).
- Спецификация Vega-Lite (`mark`, `encoding`) — блок `vega-lite`, не этот.
- Живая прямо в документе и на весь экран (кнопка «⤢»): сигналы с `bind` дают ползунки и списки под графиком, `"hover"` — подсветку.
- Не больше 128 КБ спецификации, данных из файлов — до 2 МБ на блок.

## Как чинить замечания `render_check`

- `label-overlap` у оси — `"labelOverlap": true` или `"labelAngle": -45` с `"labelAlign": "right"` у оси.
- `label-crossed` у текстовых меток — сдвиг `"dx"`/`"dy"` в `encode`, `"align"` и `"baseline"`, или метки `text` с `"from"` по другим данным.
- `too-wide` — меньше `"width"`.
