<!-- Собрано автоматически из справки render_block_docs — правки в основном репозитории Spiridus. -->

# `qet` — электрические схемы и символы QElectroTech

Схема или условное графическое обозначение, нарисованные в [QElectroTech](https://qelectrotech.org/)
— свободном редакторе электрических схем. Рисует не страница, а MCP-инструмент `qet_run`:
QElectroTech 0.200.1-dev в песочнице без экрана и сети, с библиотекой из 8839 символов. Работу
делает собственный MCP-сервер QElectroTech: операции над проектом, трассировка проводов, проверка
раскладки. Он возвращает `artifact:<id>/…` — эту строку и пишут в начале блока, а под ней — то
же задание JSON, что ушло в `qet_run`:

```qet
// result: artifact:10423b6ad24de858/folio-1.svg
// build: qelectrotech-0.200.1-dev-f4dcbcc
{
 "title": "Лампа с датчиком температуры",
 "symbols": [
  {
   "name": "sensor-t",
   "build": {
    "names": {
     "ru": "Датчик температуры",
     "en": "Temperature sensor",
     "fr": "Capteur de température"
    },
    "parts": [
     {
      "type": "rect",
      "x": -10,
      "y": -15,
      "width": 20,
      "height": 30
     },
     {
      "type": "line",
      "x1": 0,
      "y1": -20,
      "x2": 0,
      "y2": -15
     },
     {
      "type": "line",
      "x1": 0,
      "y1": 15,
      "x2": 0,
      "y2": 20
     },
     {
      "type": "text",
      "x": -6,
      "y": 3,
      "text": "t°",
      "size": 8
     }
    ],
    "terminals": [
     {
      "x": 0,
      "y": -20,
      "orientation": "n",
      "name": "1"
     },
     {
      "x": 0,
      "y": 20,
      "orientation": "s",
      "name": "2"
     }
    ],
    "informations": {
     "type": "sensor"
    }
   }
  }
 ],
 "operations": [
  {
   "op": "add_autonum",
   "kind": "conductor",
   "name": "W",
   "parts": [
    "string:W",
    "unit:1:1"
   ]
  },
  {
   "op": "use_conductor_autonum",
   "folio": 0,
   "name": "W"
  },
  {
   "op": "add_element",
   "id": "bat",
   "folio": 0,
   "path": "common://10_electric/10_allpole/392_generators_sources/30_batteries/pile_1_element.elmt",
   "x": 300,
   "y": 100
  },
  {
   "op": "rotate_element",
   "folio": 0,
   "element": "$bat",
   "angle": 90
  },
  {
   "op": "place_element",
   "id": "sw",
   "folio": 0,
   "path": "common://10_electric/10_allpole/380_signaling_operating/21_selector_switches/010_switch_1pos.elmt",
   "next_to": "$bat",
   "next_to_terminal": 1,
   "terminal": 0,
   "side": "below",
   "gap": 60
  },
  {
   "op": "place_element",
   "id": "bk",
   "folio": 0,
   "path": "custom://sensor-t.elmt",
   "next_to": "$sw",
   "next_to_terminal": 1,
   "terminal": 0,
   "side": "below",
   "gap": 60
  },
  {
   "op": "place_element",
   "id": "hl",
   "folio": 0,
   "path": "common://10_electric/10_allpole/380_signaling_operating/11_optical_signaling/lampara-azul.elmt",
   "next_to": "$bk",
   "next_to_terminal": 1,
   "terminal": 0,
   "side": "below",
   "gap": 60
  },
  {
   "op": "add_conductor",
   "folio": 0,
   "from": "$bat",
   "from_terminal": 1,
   "to": "$sw",
   "to_terminal": 0
  },
  {
   "op": "add_conductor",
   "folio": 0,
   "from": "$sw",
   "from_terminal": 1,
   "to": "$bk",
   "to_terminal": 0
  },
  {
   "op": "add_conductor",
   "folio": 0,
   "from": "$bk",
   "from_terminal": 1,
   "to": "$hl",
   "to_terminal": 0
  },
  {
   "op": "add_conductor",
   "folio": 0,
   "from": "$hl",
   "from_terminal": 1,
   "to": "$bat",
   "to_terminal": 0,
   "route": "avoid"
  },
  {
   "op": "set_label",
   "folio": 0,
   "element": "$bat",
   "label": "GB1"
  },
  {
   "op": "set_label",
   "folio": 0,
   "element": "$sw",
   "label": "SA1"
  },
  {
   "op": "set_label",
   "folio": 0,
   "element": "$bk",
   "label": "BK1"
  },
  {
   "op": "set_label",
   "folio": 0,
   "element": "$hl",
   "label": "HL1"
  },
  {
   "op": "add_element_text",
   "folio": 0,
   "element": "$bk",
   "source": "info",
   "value": "label",
   "x": 14,
   "y": -6
  }
 ]
}
```

- `// result:` — `artifact:<id>/folio-1.svg` для схемы (все листы подряд) или
  `artifact:<id>/symbol.svg` для символа; `// folio: 2` — показать только второй лист.
- `// build:` — сборка, которой нарисовано.
- `// scale: 2` — во сколько раз крупнее показать; по умолчанию символ — в 2,5 раза, схема — в 1,5
  (символ в QElectroTech — 30–60 точек). Больше колонки картинка не станет: ужмётся.
- Под схемой — кнопка `.qet`: проект для QElectroTech; под символом — `.elmt` и таблица выводов.
- Задание правили после отрисовки (сравнение — по самому JSON, отступы не важны) — блок скажет,
  что картинка для прежней версии. Без строки `result` — исходник с пометкой «не нарисовано».

## Схема

1. Символы — `qet_symbols`: поиск по названию на любом языке («лампа», «contactor coil»,
   «автоматический выключатель»), по типу и числу выводов. Ответ — `path` (`common://…`) и имена
   выводов в порядке индексов.
2. `qet_run` с `title`, `folios` и `operations` — операции как у `qet_edit`: `add_element`,
   `place_element` (символ ставится выводом в линию с соседним — провод выходит прямым),
   `add_conductor` (`"route": "avoid"` — в обход символов), `set_label`, `add_text`, `set_folio`…
   Созданное называют `"id"` и дальше ссылаются на него как `"$id"`; лист — индекс с 0.
3. После операций `qet_run` сам проверяет раскладку (`layout_check`: прямые провода, сетка,
   налезания), применяет исправления и проверяет ещё раз; в ответе — оценка, замечания и PNG.
4. Править готовый проект — `project: "artifact:<id>/project.qet"` и новые операции.

Трассировка провода не знает о подписях: обратный провод может лечь вдоль подписей символов.
Это видно только на картинке — проверяйте документ `render_check` (`label-crossed`). Помогает
цепь тока одним столбцом сверху вниз, как в примере выше, с обратным проводом `"route": "avoid"`.

Лист выгружается без рамки и штампа — только схема; `frame: true` — весь лист с рамкой и
штампом, как чертёж. Ещё выгрузить можно `pdf`, `dxf`, `bom` (спецификация), `nets`, `wires`.

## Сессия: инструменты MCP-сервера QElectroTech

Сложную схему удобнее рисовать по шагам, как в самом QElectroTech: `qet_tools` — инструменты его
собственного MCP-сервера, `qet_call` — один вызов в папке сессии (пути — относительно неё; первый
вызов без `workspace` создаёт сессию, её id — в ответе). Например: `qet_project_new` → `qet_edit` →
`qet_conductors` (провода и их участки) → `qet_layout_check` (оценка и готовые исправления) →
`qet_edit` с исправлениями → `qet_export` (`format: svg`, `output: svg`). Папка живёт 30 минут без
обращений. `qet_save` сохраняет её файлы для документа; исходник блока — журнал вызовов сессии:

```
// result: artifact:<id>/01_diagram.svg
{"calls": [{"tool": "qet_project_new", "arguments": {…}}, {"tool": "qet_edit", …}, …]}
```

## Символ

`qet_run` с `element` вместо операций:

- `{"path": "common://…"}` — символ из библиотеки: картинка, имена, выводы по порядку индексов;
- `{"build": {names, parts, terminals, link_type, informations}}` — новый символ: части `line`,
  `rect`, `ellipse`, `circle`, `arc`, `polygon`, `text` в своих координатах символа, выводы
  `{"x", "y", "orientation": "n|s|e|w", "name"}`. Размеры и точку привязки он считает сам.

```qet
// result: artifact:3b9276936c2d9ebc/symbol.svg
// build: qelectrotech-0.200.1-dev-f4dcbcc
{
 "element": {
  "build": {
   "names": {
    "ru": "Датчик температуры",
    "en": "Temperature sensor",
    "fr": "Capteur de température"
   },
   "parts": [
    {
     "type": "rect",
     "x": -10,
     "y": -15,
     "width": 20,
     "height": 30
    },
    {
     "type": "line",
     "x1": 0,
     "y1": -20,
     "x2": 0,
     "y2": -15
    },
    {
     "type": "line",
     "x1": 0,
     "y1": 15,
     "x2": 0,
     "y2": 20
    },
    {
     "type": "text",
     "x": -6,
     "y": 3,
     "text": "t°",
     "size": 8
    }
   ],
   "terminals": [
    {
     "x": 0,
     "y": -20,
     "orientation": "n",
     "name": "1"
    },
    {
     "x": 0,
     "y": 20,
     "orientation": "s",
     "name": "2"
    }
   ],
   "informations": {
    "type": "sensor"
   }
  }
 }
}
```

Обозначения (`set_label`) у своего символа на схеме не видно, пока у него нет поля для него —
добавьте `{"op": "add_element_text", "element": "$bk", "source": "info", "value": "label", "x": 14, "y": -6}`.

Кнопка `.elmt` под символом скачивает его: в QElectroTech — «Файл → Открыть» в редакторе
элементов или положить в свою коллекцию (`custom`), и символ появится в панели элементов.

Лицензии: QElectroTech — GPL-2 (запускается на сервере); символы библиотеки — «включать в схемы
без условий». Схемы с ними — ваши.


## Ядро сеанса

При включённых сеансах (`KERNEL_SESSIONS=1`) новые workspace используют своё ядро:
проект остаётся в памяти QElectroTech между командами. Снимок файлов и журнал позволяют восстановить
его после простоя, перезапуска или переноса на другой узел. Действуют общие лимиты сеансов
(два открытых на пользователя и суточный бюджет); закрыть workspace можно через `session_close`.
Старые файловые workspace доступны до истечения прежнего срока. `qet_save` сохраняет файлы папки
для документа, как прежде.

Через 30 минут без команд ядро закрывается и освобождает место в лимите сеансов. `qet_save`
читает сохранённую папку без запуска ядра и работает после `session_close`, пока папка доступна.
Имена выходных файлов и `qet_save.files` допускают Unicode и до 80 знаков в каждой части пути.

`qet_save {workspace}` без `files` сохраняет приватный пакет всей папки (`ref`:
`upload:<id>/session.json`): проекты, свои символы, результаты и журнал. SVG для пакета не нужен.
С `files` выгружаются также выбранные файлы и блок для документа, как раньше.
`session_open {from: ref}` открывает пакет; новый `id` передавайте в `qet_call` как `workspace`.
Образ проверяется на узле. `session_open {from: ref, rebuild: true}` открывает папку на основной
сборке с предупреждением; прежние правки не повторяются. Нужны `files`, права ядра и нынешний
доступ к проекту; чужой пакет не открывается. Пакет ≤ 32 МиБ, папка ≤ 300 файлов плюс служебный
журнал, учитывается в отдельной квоте загрузок (не в квоте приватных результатов).
Сохраните пакет до закрытия ядра; после закрытия доступна прежняя выгрузка `files` для документа.

## Статьи проектов

Вызывайте инструмент с `project` (editor и выше) и передавайте готовый блок в
`project_write put`: шлюз сохранит полный набор в новый каталог ресурсов и заменит
`result:` относительным путём от статьи. `project_import` переносит доступный набор
из своего `/d` тем же способом, без пересчёта. Страницы, виды и скачивания читаются
из одного коммита; отдельные файлы набора менять нельзя. Прежний набор без ссылок,
включая скрытые `%%`, убирается из головы тем же коммитом, история сохраняется.

Сверка исходника сохраняется отдельно от происхождения. Проверенный шлюзом набор
показывает «заверено шлюзом» с инструментом, сборкой и imageId. Без подтверждённого
исполнения сведения о сборке — «по данным meta.json, не заверено».
У файла без метаданных происхождение/соответствие не проверено. `private:` служит
только входом материализации, в сохранённом тексте остаются пути ресурсов.
Без `project` исходники и результаты публичны; `files_publish` для закрытых данных
не используйте. Пересчёт с сайта и проектные `async=1`/`tools.*.start` пока недоступны.

У `qet_run` контекст Spiridus задаёт `project: "slug"`, входной файл схемы — `qet_project: "private:…/project.qet"`. Прежний `project: "artifact:…/project.qet"` остаётся допустимым вводом файла; закрытый контекст при таком вызове не задаётся.

## Выбор инструмента и входного файла

`qet_run` строит схему из `operations` или правит входной `.qet` из `qet_project`;
`project` задаёт контекст проекта Spiridus (slug/id). Старое имя `project` для ссылки
`artifact:`, `private:` или `upload:` на `.qet` поддерживается для совместимости.
Для символа вместо схемы передайте `element` с ровно одним из `path` и `build`;
его нельзя сочетать с `operations` или входным файлом схемы.

`qet_tools` показывает внутренние инструменты и их схемы, `qet_call` исполняет один из них
в папке сеанса, `qet_save` сохраняет листы SVG и исходники для документа.
Это отдельные этапы, а не версии `qet_run`.
