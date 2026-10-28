<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Схемы | теги: plantuml, uml, c4, nwdiag, сеть, последовательность, классы, состояния, mindmap -->
# PlantUML: схемы из песочницы

PlantUML работает не в браузере, а на сервере: MCP-инструмент `plantuml_run` рисует схему в
песочнице и отдаёт `artifact:<id>/diagram.svg`, а блок показывает готовый SVG. Первая строка
блока — `' result: …` от инструмента, вторая — сборка. Стандартная библиотека (C4, иконки AWS,
Azure, Font Awesome, логотипы) — внутри PlantUML; интернет не нужен и не разрешён.

## Последовательность

```plantuml
' result: artifact:7cc5f65fac945583/diagram.svg
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
' result: artifact:940db6e372c37233/diagram.svg
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

```plantuml
' result: artifact:b9e3c7003037c477/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Container.puml
UpdateElementStyle("external_system", $bgColor="#4b5563", $borderColor="#374151")
!include <tupadr3/font-awesome-5/server>
!include <logos/postgresql>
Person(user, "Ученик", "читает документы и задаёт вопросы")
Person(teacher, "Учитель", "проверяет и утверждает")
System_Boundary(s, "Spiridus") {
  Container(web, "Рендер", "TypeScript", "рисует документ в браузере", $sprite="server")
  Container(mcp, "Шлюз MCP", "Node.js", "инструменты для моделей")
  Container(sb, "Песочницы", "изолированные контейнеры", "FreeCAD, PlantUML, Blender")
  ContainerDb(db, "Документы", "файлы", "", $sprite="postgresql")
}
System_Ext(llm, "LLM", "модель в комнате")
Rel(user, web, "читает")
Rel(teacher, web, "правит и утверждает")
Rel(llm, mcp, " вызывает инструменты", "MCP")
Rel(mcp, sb, " задания")
Rel(mcp, db, "пишет результат")
Rel(web, db, " берёт")
@enduml
```

## Состояния документа

```plantuml
' result: artifact:2719815268cdecd3/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
!theme plain
[*] --> Черновик
Черновик --> НаПроверке : ​   автор отправил
НаПроверке --> Черновик : замечания
НаПроверке --> Утверждён : учитель подтвердил
Утверждён --> Архив : ​   год прошёл
Архив --> [*]
НаПроверке : модель проверила render_check
Утверждён : виден ученикам
@enduml
```

## Классы

```plantuml
' result: artifact:ed4b5e72ec91ec6d/diagram.svg
' build: plantuml-1.2026.9-asl
@startuml
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
class Схема extends Блок
class Формула extends Блок
class Модель3D extends Блок
Документ "1" *-- "много" Блок
note right of Модель3D : считается в песочнице,\nстраница показывает STL
@enduml
```

## Mindmap

```plantuml
' result: artifact:49c8a145d493b3ee/diagram.svg
' build: plantuml-1.2026.9-asl
@startmindmap
* Силы в механике
** Тяжести
*** mg, к центру Земли
** Упругости
*** закон Гука F = −kx
** Трения
*** покоя
*** скольжения: μN
** Архимеда
*** ρ g V
@endmindmap
```
