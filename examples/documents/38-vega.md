<!-- Собрано из apps/playground/examples/38-vega.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Диаграммы | теги: vega, vega-lite, статистика, данные, csv, файл данных, регрессия, гистограмма, фасеты, слои, кеплер, климат -->
# Vega и Vega-Lite: графики по данным

Vega-Lite — грамматика графиков: данные, метка и какое поле на какой канал (`x`, `y`, `color`,
`column`). Vega — полная спецификация, когда нужно больше: свои шкалы, метки, сигналы. Обе
рисуются вживую: кнопка «⤢» открывает график на весь экран, с подсказками при наведении.

Данные — прямо в спецификации или **файлом документа**: блок ` ```csv file=имя.csv `, а в
спецификации `"url": "file:имя.csv"`. Файл свёрнут под заголовком «Данные» — его можно открыть
и проверить.

## Данные в спецификации

```vega-lite
{
  "$schema": "https://vega.github.io/schema/vega-lite/v6.json",
  "title": "Средний балл по четвертям (условные данные)",
  "width": 320, "height": 200,
  "data": {"values": [
    {"четверть": "I", "балл": 4.1}, {"четверть": "II", "балл": 4.3},
    {"четверть": "III", "балл": 3.9}, {"четверть": "IV", "балл": 4.4}
  ]},
  "mark": {"type": "bar", "tooltip": true},
  "encoding": {
    "x": {"field": "четверть", "type": "ordinal", "title": "Четверть", "axis": {"labelAngle": 0}},
    "y": {"field": "балл", "type": "quantitative", "title": "Средний балл", "scale": {"domain": [0, 5]}}
  }
}
```

## Файл данных: третий закон Кеплера

Квадрат периода обращения планеты пропорционален кубу большой полуоси орбиты: $T^2 \propto a^3$.
На логарифмических осях это прямая с наклоном 3/2 — все восемь планет ложатся на неё.

```csv file=планеты.csv
планета,полуось_ае,период_лет
Меркурий,0.387,0.241
Венера,0.723,0.615
Земля,1.000,1.000
Марс,1.524,1.881
Юпитер,5.203,11.86
Сатурн,9.537,29.46
Уран,19.19,84.01
Нептун,30.07,164.8
```

```vega-lite
{
  "$schema": "https://vega.github.io/schema/vega-lite/v6.json",
  "title": {"text": "Третий закон Кеплера", "subtitle": "период обращения и большая полуось орбиты"},
  "width": 420, "height": 300,
  "data": {"url": "file:планеты.csv"},
  "encoding": {
    "x": {"field": "полуось_ае", "type": "quantitative", "scale": {"type": "log"}, "title": "Большая полуось, а. е."},
    "y": {"field": "период_лет", "type": "quantitative", "scale": {"type": "log"}, "title": "Период обращения, лет"}
  },
  "layer": [
    {"mark": {"type": "line", "color": "#bbb", "strokeDash": [4, 3]}, "transform": [{"regression": "период_лет", "on": "полуось_ае", "method": "pow"}]},
    {"mark": {"type": "point", "filled": true, "size": 60, "tooltip": true}},
    {"mark": {"type": "text", "align": "left", "dx": 7, "dy": 4, "fontSize": 11}, "encoding": {"text": {"field": "планета"}}}
  ]
}
```

## Климат Москвы: два ряда на одном графике

Средняя температура и осадки по месяцам — нормы 1991–2020 годов, округлённо. Две оси Y —
слои с `"resolve": {"scale": {"y": "independent"}}`.

```csv file=москва.csv
месяц,номер,температура,осадки
янв,1,-6.2,53
фев,2,-5.9,44
мар,3,-0.5,39
апр,4,6.9,37
май,5,13.2,61
июн,6,17.0,78
июл,7,19.2,84
авг,8,17.0,82
сен,9,11.3,68
окт,10,5.6,71
ноя,11,-0.7,56
дек,12,-4.9,52
```

```vega-lite
{
  "$schema": "https://vega.github.io/schema/vega-lite/v6.json",
  "title": "Москва: температура и осадки по месяцам",
  "width": 460, "height": 260,
  "data": {"url": "file:москва.csv"},
  "encoding": {"x": {"field": "месяц", "type": "ordinal", "sort": {"field": "номер", "op": "min"}, "title": null, "axis": {"labelAngle": 0}}},
  "layer": [
    {"mark": {"type": "bar", "color": "#9ecae9", "tooltip": true},
     "encoding": {"y": {"field": "осадки", "type": "quantitative", "title": "Осадки, мм", "axis": {"titleColor": "#4c78a8"}}}},
    {"mark": {"type": "line", "color": "#e45756", "point": true, "tooltip": true},
     "encoding": {"y": {"field": "температура", "type": "quantitative", "title": "Температура, °C", "axis": {"titleColor": "#e45756"}}}}
  ],
  "resolve": {"scale": {"y": "independent"}}
}
```

## Гистограмма и фасеты

`bin` разбивает числа на интервалы, `count` считает, сколько в каждом; `column` — тот же график
отдельно для каждой категории. Данные условные: рост учеников 5 и 9 классов.

```csv file=рост.csv
класс,рост
5,142
5,146
5,139
5,151
5,148
5,144
5,137
5,149
5,145
5,153
5,141
5,147
9,162
9,170
9,158
9,175
9,166
9,169
9,172
9,160
9,168
9,181
9,164
9,171
```

```vega-lite
{
  "$schema": "https://vega.github.io/schema/vega-lite/v6.json",
  "title": "Рост учеников (условные данные)",
  "data": {"url": "file:рост.csv"},
  "mark": {"type": "bar", "tooltip": true},
  "encoding": {
    "column": {"field": "класс", "type": "ordinal", "title": "Класс"},
    "x": {"field": "рост", "type": "quantitative", "bin": {"step": 5}, "title": "Рост, см"},
    "y": {"aggregate": "count", "type": "quantitative", "title": "Учеников"},
    "color": {"field": "класс", "type": "nominal", "legend": null}
  },
  "width": 200, "height": 160
}
```

## Vega: своя спецификация

Те же столбцы, но шкалы, оси и метки задаются явно — так можно нарисовать то, чего в Vega-Lite
нет. Ползунок под графиком (сигнал с `bind`) меняет скругление столбцов.

```vega
{
  "$schema": "https://vega.github.io/schema/vega/v6.json",
  "width": 360, "height": 200, "padding": 5,
  "signals": [{"name": "скругление", "value": 2, "bind": {"input": "range", "min": 0, "max": 12, "step": 1}}],
  "data": [{"name": "t", "values": [
    {"месяц": "сен", "дни": 21}, {"месяц": "окт", "дни": 22}, {"месяц": "ноя", "дни": 16}, {"месяц": "дек", "дни": 20}
  ]}],
  "scales": [
    {"name": "x", "type": "band", "domain": {"data": "t", "field": "месяц"}, "range": "width", "padding": 0.2},
    {"name": "y", "type": "linear", "domain": {"data": "t", "field": "дни"}, "range": "height", "nice": true}
  ],
  "axes": [
    {"orient": "bottom", "scale": "x"},
    {"orient": "left", "scale": "y", "title": "Учебных дней (условно)"}
  ],
  "marks": [{
    "type": "rect", "from": {"data": "t"},
    "encode": {
      "enter": {
        "x": {"scale": "x", "field": "месяц"}, "width": {"scale": "x", "band": 1},
        "y": {"scale": "y", "field": "дни"}, "y2": {"scale": "y", "value": 0},
        "fill": {"value": "#4c78a8"}, "tooltip": {"field": "дни"}
      },
      "update": {"cornerRadiusTopLeft": {"signal": "скругление"}, "cornerRadiusTopRight": {"signal": "скругление"}}
    }
  }]
}
```
