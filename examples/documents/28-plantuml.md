<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Схемы | теги: plantuml, uml, c4, nwdiag, сеть, последовательность, классы, состояния, mindmap -->
# PlantUML: схемы из песочницы

PlantUML работает не в браузере, а на сервере: MCP-инструмент `plantuml_run` рисует схему в
песочнице и отдаёт `artifact:<id>/diagram.svg`, а блок показывает готовый SVG. Первая строка
блока — `' result: …` от инструмента, вторая — сборка. Стандартная библиотека (C4, иконки AWS,
Azure, Font Awesome, логотипы) — внутри PlantUML; интернет не нужен и не разрешён.

## Последовательность

```plantuml
' result: artifact:cde6602206eba345/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
!theme plain
actor Ученик
participant "Модель" as M
database "Документ" as D
Ученик -> M: вопрос по задаче
M -> D: читает условие
D --> M: текст
M --> Ученик: подсказка, не ответ
@enduml
```

## Сетевая схема nwdiag

Подсети полосами; адреса узлов — в подписи узла (`description`), а не полем `address`: его nwdiag пишет поверх линии подключения.

```plantuml
' result: artifact:1af5ae8c6eaa2af2/diagram.svg
' build: plantuml-1.2026.9-asl
@startnwdiag
nwdiag {
  network dmz {
    address = "203.0.113.0/24"
    web01 [description = "web01\n203.0.113.10\n10.0.0.10"];
    web02 [description = "web02\n203.0.113.11\n10.0.0.11"];
  }
  network internal {
    address = "10.0.0.0/24";
    web01;
    web02;
    db01 [description = "db01\n10.0.0.20"];
  }
}
@endnwdiag
```

## C4: контейнеры

`!include` с адреса C4-PlantUML на GitHub шлюз сам подменил на копию из стандартной библиотеки
и сообщил об этом в ответе.

Два вида одной системы: чтение и утверждение документов; инструменты модели и песочницы. Контейнер «Документы» общий.

Внешние участники и их обращения к рендеру:

```plantuml
' result: artifact:065d0643c0ad017a/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
skinparam defaultFontSize 16
!include <C4/C4_Context>
LAYOUT_TOP_DOWN()
Person(user, "Ученик", "читает документы\nи задаёт вопросы")
Person(teacher, "Учитель", "проверяет\nи утверждает")
System(s, "Spiridus", "Рендер документа")
Rel_D(user, s, "читает")
Rel_D(teacher, s, "правит\nи утверждает")
@enduml
```

Внутренние контейнеры Spiridus:

```plantuml
' result: artifact:e2aaa7e09142c3ba/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
skinparam defaultFontSize 16
skinparam wrapWidth 140
skinparam maxMessageSize 100
skinparam nodesep 25
skinparam ranksep 40
!include <C4/C4_Container>
LAYOUT_TOP_DOWN()
UpdateElementStyle("external_system", $bgColor="#4b5563", $borderColor="#374151")
!include <tupadr3/font-awesome-5/server>
!include <logos/postgresql>
System_Boundary(s, "Spiridus") {
  Container(web, "Рендер", "TypeScript", "рисует документ в браузере", $sprite="server")
  ContainerDb(db, "Документы", "файлы", "", $sprite="postgresql")
}
Rel_D(web, db, " берёт")
@enduml
```

Внешние участники и их обращения к шлюзу MCP:

```plantuml
' result: artifact:ea9c2d5abfc56f13/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
skinparam defaultFontSize 16
!include <C4/C4_Context>
LAYOUT_TOP_DOWN()
UpdateElementStyle("external_system", $bgColor="#4b5563", $borderColor="#374151")
System_Ext(llm, "LLM", "модель в комнате")
System(s, "Spiridus", "Шлюз MCP")
Rel_D(llm, s, "​        вызывает\n​        инструменты по MCP")
@enduml
```

Внутренние контейнеры Spiridus:

```plantuml
' result: artifact:7992218a122b0955/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
skinparam defaultFontSize 16
skinparam wrapWidth 140
skinparam maxMessageSize 100
skinparam nodesep 25
skinparam ranksep 40
!include <C4/C4_Container>
LAYOUT_TOP_DOWN()
UpdateElementStyle("external_system", $bgColor="#4b5563", $borderColor="#374151")
!include <tupadr3/font-awesome-5/server>
!include <logos/postgresql>
System_Boundary(s, "Spiridus") {
  Container(mcp, "Шлюз MCP", "Node.js", "инструменты для моделей")
  Container(sb, "Песочницы", "изолированные контейнеры", "FreeCAD, PlantUML, Blender")
}
Rel_D(mcp, sb, " задания")
@enduml
```

```plantuml
' result: artifact:20f25b277ef3cb8b/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
skinparam defaultFontSize 16
skinparam wrapWidth 140
skinparam maxMessageSize 100
skinparam nodesep 25
skinparam ranksep 40
!include <C4/C4_Container>
LAYOUT_TOP_DOWN()
UpdateElementStyle("external_system", $bgColor="#4b5563", $borderColor="#374151")
!include <tupadr3/font-awesome-5/server>
!include <logos/postgresql>
System_Boundary(s, "Spiridus") {
  Container(mcp, "Шлюз MCP", "Node.js", "инструменты для моделей")
  ContainerDb(db, "Документы", "файлы", "", $sprite="postgresql")
}
Rel_D(mcp, db, "​        пишет\n​        результат")
@enduml
```

## Состояния документа

```plantuml
' result: artifact:e740a7eb07322bd3/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
skinparam defaultFontSize 16
skinparam wrapWidth 140
skinparam maxMessageSize 100
skinparam nodesep 25
skinparam ranksep 40
!theme plain
[*] --> Черновик
Черновик --> НаПроверке : ​        автор отправил
НаПроверке --> Черновик : замечания
НаПроверке --> Утверждён : учитель подтвердил
Утверждён --> Архив : ​        год прошёл
Архив --> [*]
НаПроверке : модель проверила\nrender_check
Утверждён : виден ученикам
@enduml
```

## Классы

```plantuml
' result: artifact:49c5d1dc9f8b4831/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
skinparam defaultFontSize 16
skinparam wrapWidth 140
skinparam maxMessageSize 100
skinparam nodesep 25
skinparam ranksep 40
skinparam classAttributeIconSize 0
class Документ {
  +заголовок: string
  +блоки: Блок[]
  +проверить(): Отчёт
}
abstract class Блок {
  +язык: string
  +исходник: string
  {abstract} +нарисовать()
}
Документ "1" *-down- "много" Блок
@enduml
```

Реализации одного абстрактного контракта; повторённый «Блок» — тот же класс.

```plantuml
' result: artifact:98450800ef3694c8/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
skinparam defaultFontSize 16
skinparam wrapWidth 140
skinparam maxMessageSize 100
skinparam nodesep 25
skinparam ranksep 40
skinparam classAttributeIconSize 0
abstract class Блок {
  +язык: string
  +исходник: string
  {abstract} +нарисовать()
}
class Схема extends Блок
@enduml
```

```plantuml
' result: artifact:d50810cf68700f1a/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
skinparam defaultFontSize 16
skinparam wrapWidth 140
skinparam maxMessageSize 100
skinparam nodesep 25
skinparam ranksep 40
skinparam classAttributeIconSize 0
abstract class Блок {
  +язык: string
  +исходник: string
  {abstract} +нарисовать()
}
class Формула extends Блок
@enduml
```

```plantuml
' result: artifact:19886c3bf8fdadc5/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
skinparam defaultFontSize 16
skinparam wrapWidth 140
skinparam maxMessageSize 100
skinparam nodesep 25
skinparam ranksep 40
skinparam classAttributeIconSize 0
abstract class Блок {
  +язык: string
  +исходник: string
  {abstract} +нарисовать()
}
class Модель3D extends Блок
note bottom of Модель3D : считается в песочнице,\nстраница показывает STL
@enduml
```

## Mindmap

Четыре ветви одной карты «Силы в механике»:

```plantuml
' result: artifact:c67e82fbf38c53a7/diagram.svg
' build: plantuml-1.2026.9-asl
@startmindmap
skinparam defaultFontSize 18
* Силы\nв механике
** Тяжести
*** mg, к центру\nЗемли
@endmindmap
```

```plantuml
' result: artifact:6ed2a9cc64e61f1b/diagram.svg
' build: plantuml-1.2026.9-asl
@startmindmap
skinparam defaultFontSize 18
* Силы\nв механике
** Упругости
*** закон Гука\nF = −kx
@endmindmap
```

```plantuml
' result: artifact:397c75b20f6890d0/diagram.svg
' build: plantuml-1.2026.9-asl
@startmindmap
skinparam defaultFontSize 18
* Силы\nв механике
** Трения
*** покоя
*** скольжения:\nμN
@endmindmap
```

```plantuml
' result: artifact:4457bf49d3851170/diagram.svg
' build: plantuml-1.2026.9-asl
@startmindmap
skinparam defaultFontSize 18
* Силы\nв механике
** Архимеда
*** ρ g V
@endmindmap
```
