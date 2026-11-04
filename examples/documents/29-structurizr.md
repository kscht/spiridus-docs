<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Схемы | теги: structurizr, c4, архитектура, dsl, контекст, контейнеры -->
# Structurizr: модель C4

Одна модель на Structurizr DSL — несколько видов. MCP-инструмент `structurizr_run` проверяет DSL,
выгружает виды в C4-PlantUML и рисует их PlantUML в песочнице; блок показывает вид из артефакта.
Первая строка — `# result:` от инструмента; другой вид того же результата — строка `# view:`.

Полная модель повторена без изменений в четырёх видах. Все исходные участники, контейнеры, описания и связи сохранены; общие узлы объединяют виды.

## Контекст: читатель и учитель

```structurizr
# result: artifact:8d889961808ad1ba/SystemContextReaders.svg
# view: SystemContextReaders
# build: structurizr-2025.11.09
workspace "Spiridus" "Комнаты людей и моделей вокруг документов" {
  model {
    user = person "Ученик" "читает документы\nи задаёт\nвопросы"
    teacher = person "Учитель" "проверяет и утверждает"
    spiridus = softwareSystem "Spiridus" {
      web = container "Рендер" "рисует документ" "TypeScript"
      mcp = container "Шлюз MCP" "инструменты для моделей" "Node.js"
      sb = container "Песочницы" "FreeCAD, PlantUML, Blender" "изолированные контейнеры"
      db = container "Документы" "файлы" "диск" "Database"
    }
    llm = softwareSystem "LLM" "модель в комнате" "External"
    user -> web "читает"
    teacher -> web "​        правит\nи утверждает\n"
    llm -> mcp "​        вызывает\n​        инструменты по MCP\n"
    mcp -> sb "​        задания\n"
    mcp -> db "пишет результат\n"
    web -> db "​        берёт\n"
  }
  views {
    properties {
      "c4plantuml.legend" "false"
    }
    systemContext spiridus "SystemContextReaders" {
      include user teacher spiridus
      autolayout tb
    }
    systemContext spiridus "SystemContextLLM" {
      include llm spiridus
      autolayout tb
    }
    container spiridus "ReaderContainers" {
      include web db
      autolayout tb
    }
    container spiridus "ModelContainers" {
      include mcp sb db
      autolayout tb
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

## Контекст: модель

```structurizr
# result: artifact:8d889961808ad1ba/SystemContextReaders.svg
# view: SystemContextLLM
# build: structurizr-2025.11.09
workspace "Spiridus" "Комнаты людей и моделей вокруг документов" {
  model {
    user = person "Ученик" "читает документы\nи задаёт\nвопросы"
    teacher = person "Учитель" "проверяет и утверждает"
    spiridus = softwareSystem "Spiridus" {
      web = container "Рендер" "рисует документ" "TypeScript"
      mcp = container "Шлюз MCP" "инструменты для моделей" "Node.js"
      sb = container "Песочницы" "FreeCAD, PlantUML, Blender" "изолированные контейнеры"
      db = container "Документы" "файлы" "диск" "Database"
    }
    llm = softwareSystem "LLM" "модель в комнате" "External"
    user -> web "читает"
    teacher -> web "​        правит\nи утверждает\n"
    llm -> mcp "​        вызывает\n​        инструменты по MCP\n"
    mcp -> sb "​        задания\n"
    mcp -> db "пишет результат\n"
    web -> db "​        берёт\n"
  }
  views {
    properties {
      "c4plantuml.legend" "false"
    }
    systemContext spiridus "SystemContextReaders" {
      include user teacher spiridus
      autolayout tb
    }
    systemContext spiridus "SystemContextLLM" {
      include llm spiridus
      autolayout tb
    }
    container spiridus "ReaderContainers" {
      include web db
      autolayout tb
    }
    container spiridus "ModelContainers" {
      include mcp sb db
      autolayout tb
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

## Контейнеры: документы

```structurizr
# result: artifact:8d889961808ad1ba/SystemContextReaders.svg
# view: ReaderContainers
# build: structurizr-2025.11.09
workspace "Spiridus" "Комнаты людей и моделей вокруг документов" {
  model {
    user = person "Ученик" "читает документы\nи задаёт\nвопросы"
    teacher = person "Учитель" "проверяет и утверждает"
    spiridus = softwareSystem "Spiridus" {
      web = container "Рендер" "рисует документ" "TypeScript"
      mcp = container "Шлюз MCP" "инструменты для моделей" "Node.js"
      sb = container "Песочницы" "FreeCAD, PlantUML, Blender" "изолированные контейнеры"
      db = container "Документы" "файлы" "диск" "Database"
    }
    llm = softwareSystem "LLM" "модель в комнате" "External"
    user -> web "читает"
    teacher -> web "​        правит\nи утверждает\n"
    llm -> mcp "​        вызывает\n​        инструменты по MCP\n"
    mcp -> sb "​        задания\n"
    mcp -> db "пишет результат\n"
    web -> db "​        берёт\n"
  }
  views {
    properties {
      "c4plantuml.legend" "false"
    }
    systemContext spiridus "SystemContextReaders" {
      include user teacher spiridus
      autolayout tb
    }
    systemContext spiridus "SystemContextLLM" {
      include llm spiridus
      autolayout tb
    }
    container spiridus "ReaderContainers" {
      include web db
      autolayout tb
    }
    container spiridus "ModelContainers" {
      include mcp sb db
      autolayout tb
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

## Контейнеры: инструменты

```structurizr
# result: artifact:8d889961808ad1ba/SystemContextReaders.svg
# view: ModelContainers
# build: structurizr-2025.11.09
workspace "Spiridus" "Комнаты людей и моделей вокруг документов" {
  model {
    user = person "Ученик" "читает документы\nи задаёт\nвопросы"
    teacher = person "Учитель" "проверяет и утверждает"
    spiridus = softwareSystem "Spiridus" {
      web = container "Рендер" "рисует документ" "TypeScript"
      mcp = container "Шлюз MCP" "инструменты для моделей" "Node.js"
      sb = container "Песочницы" "FreeCAD, PlantUML, Blender" "изолированные контейнеры"
      db = container "Документы" "файлы" "диск" "Database"
    }
    llm = softwareSystem "LLM" "модель в комнате" "External"
    user -> web "читает"
    teacher -> web "​        правит\nи утверждает\n"
    llm -> mcp "​        вызывает\n​        инструменты по MCP\n"
    mcp -> sb "​        задания\n"
    mcp -> db "пишет результат\n"
    web -> db "​        берёт\n"
  }
  views {
    properties {
      "c4plantuml.legend" "false"
    }
    systemContext spiridus "SystemContextReaders" {
      include user teacher spiridus
      autolayout tb
    }
    systemContext spiridus "SystemContextLLM" {
      include llm spiridus
      autolayout tb
    }
    container spiridus "ReaderContainers" {
      include web db
      autolayout tb
    }
    container spiridus "ModelContainers" {
      include mcp sb db
      autolayout tb
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
