<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Схемы | теги: structurizr, c4, архитектура, dsl, контекст, контейнеры -->
# Structurizr: модель C4

Одна модель на Structurizr DSL — несколько видов. MCP-инструмент `structurizr_run` проверяет DSL,
выгружает виды в C4-PlantUML и рисует их PlantUML в песочнице; блок показывает вид из артефакта.
Первая строка — `# result:` от инструмента; другой вид того же результата — строка `# view:`.

## Контекст системы

```structurizr
# result: artifact:f2149cd49587f195/SystemContext.svg
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
    llm -> mcp "вызывает инструменты по MCP\n"
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

## Контейнеры

Тот же исходник, другой вид:

```structurizr
# result: artifact:a816bfdff5db9039/SystemContext.svg
# view: Containers
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
    llm -> mcp "вызывает инструменты по MCP\n"
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
