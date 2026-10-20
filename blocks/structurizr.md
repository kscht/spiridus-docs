<!-- Собрано из packages/render/src/blocks/structurizr/docs.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

# `structurizr` — модель C4 на Structurizr DSL

Архитектура ПО по модели C4 на [Structurizr DSL](https://docs.structurizr.com/dsl): люди,
системы, контейнеры, компоненты, связи и виды. Рисует не страница, а MCP-инструмент
`structurizr_run`: Structurizr CLI проверяет DSL, выгружает виды в C4-PlantUML, PlantUML рисует —
всё в песочнице без сети. Инструмент возвращает `artifact:<id>/<вид>.svg` и список видов; строку
результата пишут первой в блоке комментарием DSL:

```structurizr
# result: artifact:d07612ab232d3110/SystemContext.svg
# build: structurizr-2025.11.09
workspace "Spiridus" "Комнаты людей и моделей вокруг документов" {
  model {
    user = person "Ученик" "читает документы и задаёт вопросы"
    teacher = person "Учитель" "проверяет и утверждает"
    spiridus = softwareSystem "Spiridus" {
      web = container "Рендер" "рисует документ" "TypeScript"
      mcp = container "Шлюз MCP" "инструменты для моделей" "Node.js"
      sb = container "Песочницы" "FreeCAD, PlantUML, Blender" "изолированные контейнеры"
      db = container "Документы" "файлы" "диск" "Database"
    }
    llm = softwareSystem "LLM" "модель в комнате" "External"
    user -> web "читает"
    teacher -> web "правит и утверждает\n"
    llm -> mcp "вызывает инструменты" "MCP"
    mcp -> sb "задания\n"
    mcp -> db "пишет результат\n"
    web -> db "берёт\n"
  }
  views {
    properties {
      "c4plantuml.legend" "false"
    }
    systemContext spiridus "SystemContext" {
      include *
      autolayout lr
    }
    container spiridus "Containers" {
      include *
      autolayout lr
    }
    styles {
      element "Person" {
        shape person
        background #1f4e79
        color #ffffff
      }
      element "External" {
        background #999999
        color #ffffff
      }
      element "Database" {
        shape cylinder
      }
    }
  }
}
```

- `# result:` — вид по умолчанию, его даёт инструмент (первый вид модели).
- `# view: Containers` — показать другой вид того же артефакта; ключ вида — второй аргумент
  `systemContext`, `container`, `component`, `deployment`, `dynamic`. Чтобы показать несколько
  видов, повторите блок с тем же `result` и разными `view` (исходник один и тот же).
- `# build:` — сборка песочницы, для сверки.

Каждому виду нужен `autolayout` (`lr`, `tb`): координат в DSL нет, их считает Graphviz. DSL
построчный: `include *` и `autolayout` — на своих строках, не в одной с `{`.
`!script` разрешён (выполняется в песочнице), `!include`, `!docs`, `!adrs`, `!plugin` — нет:
ни файлов, ни сети, всё в одном блоке. Темы по адресу (`theme https://…`) не работают, стили —
в `styles`. Не больше 256 КБ. После правки DSL вызывайте `structurizr_run` снова: расхождение
исходника с нарисованным показывается под схемой.

Ловушки:
- Ключ вида обязателен, если на него ссылаться из `view:`; без ключа Structurizr придумает свой.
- Виды `dynamic` и `deployment` рисуются тем же путём; `image` views и `filtered` — нет.
- Широкие контейнерные виды с десятком элементов в `lr` на телефоне мелкие — `render_check`
  скажет; делите на виды или ставьте `autolayout tb`.

## Как чинить замечания `render_check`

`render_check` смотрит внутрь рисунка: `label-crossed` — линия через подпись, `label-tight` — линия касается подписи, `label-overlap` — подписи налезают, `label-outside` — подпись шире своей фигуры, `label-small` — после ужатия под колонку мельче 9 точек. В замечании — текст подписи, а в ответе — вырез места (`label-<строка>-<n>.png`).

- `label-tight` у подписи связи — `autolayout tb` вместо `lr` (или наоборот), больше промежуток: `autolayout lr 300 300`; короче описание связи.
- `label-small` — вид шире колонки: разделите на виды (контекст отдельно, контейнеры отдельно), `autolayout tb`.
