<!-- Собрано автоматически из документов-примеров Spiridus — правки в основном репозитории Spiridus. -->

<!-- раздел: Схемы | теги: qelectrotech, электрическая схема, символ, условное обозначение, elmt, гост, электротехника, физика -->
# QElectroTech: схемы и символы

Электрические схемы и условные обозначения из [QElectroTech](https://qelectrotech.org/) — свободного
редактора электрических схем. Рисует их MCP-инструмент `qet_run`: QElectroTech в песочнице на
сервере, без экрана, с библиотекой из 8839 символов; работу делает собственный MCP-сервер
QElectroTech. В блоке — задание JSON и строка с результатом; под картинкой — файлы для импорта в
QElectroTech.

## Символ из библиотеки

Символ находят инструментом `qet_symbols` по названию на любом языке, а `qet_run` с `element.path`
показывает его и описывает выводы — в том порядке, в каком к ним подключают провода.

```qet
// result: artifact:595dd3e3709f2713/symbol.svg
// build: qelectrotech-0.200.1-dev-f4dcbcc
{
 "element": {
  "path": "common://10_electric/10_allpole/380_signaling_operating/11_optical_signaling/lampara-azul.elmt"
 }
}
```

## Свой символ

Нового символа в библиотеке нет — его описывают частями: прямоугольники, линии, тексты и выводы в
координатах символа. Кнопка `.elmt` скачивает его для QElectroTech: в редакторе элементов —
«Файл → Открыть», или в свою коллекцию, и символ появится в панели элементов.

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

## Схема со своим символом

Свои символы описывают в задании схемы (`symbols`) и ставят на неё как `custom://<имя>.elmt`. Цепь
тока — одним столбцом, как принято в схемах по МЭК: источник GB1, выключатель SA1, датчик BK1,
лампа HL1; провода нумеруются сами (W1…W4), обратный провод идёт сбоку. У своего символа нет
поля для обозначения — его добавляет `add_element_text` с `source: "info"` и `value: "label"`. После операций `qet_run`
проверяет раскладку и правила оформления. Под схемой — проект `.qet` и символ датчика.

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
