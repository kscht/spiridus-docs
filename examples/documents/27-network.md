<!-- Собрано из apps/playground/examples/27-network.md основного репозитория Spiridus (scripts/build-public-docs.mjs) — правьте там. -->

<!-- раздел: Схемы | теги: сеть, сетевой инженер, топология, иконки, d2, mermaid, провайдер, vlan, офис -->
# Схемы сети с иконками

Иконки берутся из наших наборов (`render_icons`): `affinity` — сетевые, цветные; `mdi` —
значки устройств; `logos` — логотипы продуктов. Схемы живые: кнопка «⤢» открывает их на весь
экран.

## D2: узел провайдера

Контейнеры — площадки и VLAN, узлы-иконки (`shape: image`) с подписью справа (`label.near: outside-right-center`) — снизу её пересекали бы связи; раскладка dagre ведёт связи к самим значкам.

```d2
classes: { dev: { shape: image; label.near: outside-right-center } }
direction: down
inet: Интернет\nAS64500 { class: dev; icon: affinity:globe }
uplink1: Аплинк 1\n10 Гбит/с { class: dev; icon: affinity:link-gray }
uplink2: Аплинк 2\n10 Гбит/с { class: dev; icon: affinity:link-gray }
inet -> uplink1
inet -> uplink2

pop: Узел связи, ул. Ленина 1 {
  br1: Граничный маршрутизатор 1\n203.0.113.1 { class: dev; icon: affinity:router }
  br2: Граничный маршрутизатор 2\n203.0.113.2 { class: dev; icon: affinity:router }
  br1 <-> br2: iBGP, VRRP
  fw: Межсетевой экран\nкластер { class: dev; icon: affinity:firewall-red }
  br1 -> fw
  br2 -> fw
  core: Ядро\nкоммутатор L3 { class: dev; icon: affinity:switch-multilayer }
  fw -> core
  srv: Серверная {
    label.near: bottom-center
    dns: DNS, DHCP\n10.0.10.5 { class: dev; icon: affinity:server-green }
    mon: Мониторинг\n10.0.10.7 { class: dev; icon: affinity:statistics-green }
    nas: Хранилище\n10.0.10.20 { class: dev; icon: affinity:nas-green }
  }
  core -> srv.dns
  core -> srv.mon
  core -> srv.nas
  olt: OLT\nGPON { class: dev; icon: affinity:interconnect }
  core -> olt: VLAN 100–199
}
uplink1 -> pop.br1
uplink2 -> pop.br2

abon: Абоненты {
  h1: Дом\n100 квартир { class: dev; icon: affinity:office-gray }
  h2: Частный сектор { class: dev; icon: affinity:house-gray }
  ont: Розетка у абонента { class: dev; icon: affinity:rj45-gray }
}
pop.olt -> abon.h1: сплиттер 1:32
pop.olt -> abon.h2: сплиттер 1:64
abon.h1 -> abon.ont
```

## Mermaid: офисная сеть, схема архитектуры

В `architecture-beta` подпись стоит под значком, и вертикальная связь прошла бы через неё —
поэтому связи только по горизонтали, цепочкой; ветвления сети удобнее рисовать в D2 (выше).

```mermaid
architecture-beta
  group inet(affinity:globe)[Интернет]
  group dmz(affinity:shield)[ДМЗ]
  group lan(affinity:office)[ЛВС]

  service isp(affinity:router-gray)[Провайдер] in inet
  service fw(affinity:firewall-red)[Экран] in dmz
  service web(logos:nginx)[Веб] in dmz
  service core(affinity:switch-multilayer)[Ядро] in lan
  service db(logos:postgresql)[База] in lan

  isp:R -- L:fw
  fw:R -- L:web
  web:R -- L:core
  core:R -- L:db
```

## Mermaid: разбор инцидента со значками Material

```mermaid
flowchart TD
  A@{ icon: "mdi:bell", form: "circle", label: "Тревога: нет связи с филиалом", pos: "b" }
  B@{ icon: "mdi:lan-disconnect", form: "square", label: "Проверить линк на коммутаторе" }
  C@{ icon: "mdi:router-wireless", form: "square", label: "Проверить маршрутизатор филиала" }
  D@{ icon: "mdi:vpn", form: "square", label: "Поднять туннель заново" }
  E@{ icon: "mdi:check-circle", form: "circle", label: "Связь восстановлена", pos: "b" }
  A --> B
  B -->|линк есть| C
  B -->|линка нет| F[Вызвать монтажника]
  C --> D --> E
```

## Mermaid: тот же узел контурными иконками

Набор `-line` — без фона, для чёрно-белой печати.

```mermaid
flowchart LR
  I@{ icon: "affinity:cloud-line", form: "square", label: "Интернет" }
  R@{ icon: "affinity:router-line", form: "square", label: "Маршрутизатор" }
  S@{ icon: "affinity:switch-line", form: "square", label: "Коммутатор" }
  P@{ icon: "affinity:printer-line", form: "square", label: "Принтер" }
  C@{ icon: "affinity:client-line", form: "square", label: "ПК" }
  I --- R --- S
  S --- P
  S --- C
```

## Ошибка

Иконка по адресу в интернете не принимается:

```d2
x: Сервер { icon: https://example.com/server.svg }
```
