<!-- Собрано из notations/structurizr/docs.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

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
- Раскладки — только `tb` и `lr`: `autolayout bt` и `rl` выгрузка в C4-PlantUML не различает.
- Заголовок вида без `title` — английский («Container View: Spiridus»). Свой — строкой `title` внутри
  вида: `title "Контейнеры Spiridus"`.
- `styles` (цвета, `shape`) по умолчанию до рисунка не доходят: выгрузка не передаёт метки. Чтобы
  они применились — `"c4plantuml.tags" "true"` в `properties`; тогда у элементов без своего стиля
  цвета Structurizr (белые прямоугольники, пунктирные связи), так что задайте стиль и для
  `"Container"`, `"Software System"`, `"Relationship"`.

## Как чинить замечания `render_check`

`render_check` смотрит внутрь рисунка: `label-crossed` — линия через подпись, `label-tight` — линия касается подписи, `label-overlap` — подписи налезают, `label-outside` — подпись шире своей фигуры, `label-small` — после ужатия под колонку мельче 9 точек. В замечании — текст подписи, а в ответе — вырез места (`label-<строка>-<n>.png`).

- `label-crossed` через заголовок границы («Spiridus [system]») в контейнерном виде — связь снаружи
  входит в границу сверху, к её верхнему элементу, и Graphviz ведёт её ровно через заголовок.
  Раскладкой это не лечится (`linetype`, `ranksep`, `autolayout bt` не помогают). Внешние связи —
  в отдельный вид `systemContext`, а в контейнерном их не показывать: `exclude claude tester` после
  `include *`. Или `autolayout lr` — без пересечения, но рисунок вдвое шире.
- `label-tight` у подписи вертикальной связи (`autolayout tb`, подпись справа от линии) — отступ
  знаком нулевой ширины и пробелами в начале описания: `a -> b "​   задания"`. Пустая строка под
  подписью (`"задания\n"`) помогает только горизонтальным связям (`autolayout lr`).
- `label-tight` у подписи связи — ещё: больше промежуток (`autolayout lr 300 300`), короче описание.
- `label-small` — вид шире колонки: разделите на виды (контекст отдельно, контейнеры отдельно), `autolayout tb`.
