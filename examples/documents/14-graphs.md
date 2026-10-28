<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Схемы | теги: graphviz, dot, d2, граф, дерево, автомат, архитектура, схема, сеть, таблицы, er -->
# Графы: Graphviz и D2

## Graphviz: конечный автомат

Автомат принимает двоичные числа, кратные трём.

```dot
digraph {
  rankdir=LR
  node [shape=circle, style=filled, fillcolor="#eef4ff"]
  start [shape=point]
  start -> r0
  r0 [shape=doublecircle, label="ост. 0"]
  r1 [label="ост. 1"]
  r2 [label="ост. 2"]
  r0 -> r0 [label="0"]
  r0 -> r1 [label="1"]
  r1 -> r0 [label="1"]
  r1 -> r2 [label="0"]
  r2 -> r1 [label="0"]
  r2 -> r2 [label="1"]
}
```

## Graphviz: дерево разбора выражения

```dot
graph {
  node [shape=box, style=rounded]
  plus [label="+"]; times [label="×"]; minus [label="−"]
  a; b; c; d
  plus -- times; plus -- minus
  times -- a; times -- b
  minus -- c; minus -- d
}
```

## Graphviz: молекула воды раскладкой neato

```dot
// engine: neato
graph {
  node [shape=circle, style=filled, fontcolor=white]
  O [fillcolor="#d33", width=0.8]
  H1 [label="H", fillcolor="#777"]
  H2 [label="H", fillcolor="#777"]
  O -- H1 [len=1.2]
  O -- H2 [len=1.2]
  H1 -- H2 [style=invis, len=1.9]
}
```

## Graphviz: систематика растений

```dot
digraph {
  rankdir=LR
  node [shape=ellipse]
  Растения -> {Мхи; Папоротники; Голосеменные; Покрытосеменные}
  Покрытосеменные -> {Однодольные; Двудольные}
}
```

## D2: архитектура проекта

```d2
vars: { d2-config: { layout-engine: elk } }
Браузер: {
  Рендер: {shape: hexagon}
  Документ: {shape: page}
}
Сервер: {
  label.near: top-left
  Сайт
  Шлюз MCP
  Песочницы: {
    FreeCAD: {shape: cylinder}
  }
  Сайт -> Шлюз MCP: /mcp
  Шлюз MCP -> Песочницы: задание
}
LLM: {shape: cloud}
Браузер.Рендер -> Сервер.Сайт: статика
LLM -> Сервер.Шлюз MCP: {source-arrowhead.label: инструменты}
```

## D2: таблицы базы данных

```d2
Ученик: {
  shape: sql_table
  id: int {constraint: primary_key}
  имя: text
  класс_id: int {constraint: foreign_key}
}
Класс: {
  shape: sql_table
  id: int {constraint: primary_key}
  номер: text
}
Ученик.класс_id -> Класс.id
```

## D2: последовательность и Markdown

```d2
Проверка: {
  shape: sequence_diagram
  Ученик -> Модель: решение
  Модель -> Учитель: черновик оценки
  Учитель -> Ученик: отзыв
}
Пояснение: |md
  ## Правило
  Оценку **всегда** утверждает учитель.
|
```

## D2: эскиз и ELK

```d2
vars: {
  d2-config: {
    layout-engine: elk
    sketch: true
  }
}
Идея -> Черновик -> Обсуждение -> Документ
Обсуждение -> Черновик: правки
```
